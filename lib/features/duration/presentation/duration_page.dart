import 'package:datav8/core/themes/custom_theme.dart';
import 'package:datav8/core/utils/ui_const.dart';
import 'package:datav8/core/widgets/appbar_common.dart';
import 'package:datav8/core/widgets/default_margin_widget.dart';
import 'package:datav8/core/widgets/duration_card.dart';
import 'package:datav8/features/chart/presentation/chart_page.dart';
import 'package:datav8/features/duration/data/chart_controller.dart';
import 'package:datav8/features/duration/data/controller/duration_pick_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class DurationPage extends StatelessWidget {
  final String deviceName;

  /// Raw IMEI for API requests (may be empty if the account has no IMEI for this row).
  final String imei;

  const DurationPage({super.key, required this.deviceName, required this.imei});

  @override
  Widget build(BuildContext context) {
    final theme = CustomTheme.of(context);
    return GetBuilder<ChartController>(
      builder: (cc) {
        return GetBuilder<DurationPickController>(
          builder: (c) {
            return Stack(
              children: [
                Scaffold(
                  appBar: appbarCommon(deviceName, context),
                  body: Container(
                    color: theme.greyBg,
                    child: DefaultMarginWidget(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          gapH(25),
                          MasonryGridView.count(
                            crossAxisCount: 2,
                            itemCount: 3,
                            shrinkWrap: true,
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 20,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return DurationCard(
                                title: c.titles[index],
                                selected: c.selected == c.options[index],
                                onTap: () async {
                                  c.setSelected(c.options[index]);
                                  final ok = await cc.retrieveForDevice(
                                    imei,
                                    c.options[index],
                                  );
                                  if (!context.mounted || !ok) return;
                                  Get.to(
                                    ChartPage(
                                      deviceName: deviceName,
                                      duration: c.chartDurationLabel,
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (cc.isLoading) ...[
                  Positioned.fill(
                    child: ModalBarrier(
                      dismissible: false,
                      color: Colors.black.withValues(alpha: 0.2),
                    ),
                  ),
                  const Positioned.fill(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ],
              ],
            );
          },
        );
      },
    );
  }
}
