import 'package:datav8/core/themes/custom_theme.dart';
import 'package:datav8/core/utils/text_utils.dart';
import 'package:datav8/core/widgets/appbar_common.dart';
import 'package:datav8/core/widgets/custom_card.dart';
import 'package:datav8/core/widgets/default_margin_widget.dart';
import 'package:datav8/features/auth/data/controller/auth_controller.dart';
import 'package:datav8/features/duration/presentation/duration_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = CustomTheme.of(context);

    return GetBuilder<AuthController>(
      builder: (ac) {
        final devices = ac.userData?.pairedDevices ?? [];
        return Scaffold(
          appBar: appbarCommon('Device list', hasBackButton: false, context),
          body: Container(
            color: theme.greyBg,
            child: Column(
              children: [
                Expanded(
                  child: DefaultMarginWidget(
                    child: devices.isEmpty
                        ? Center(
                            child: Text(
                              'No devices',
                              style: TextUtils.b1Regular(
                                context: context,
                                color: theme.greyDark,
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.only(top: 25, bottom: 25),
                            itemCount: devices.length,
                            itemBuilder: (ctx, index) {
                              final d = devices[index];
                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom: index < devices.length - 1 ? 25 : 0,
                                ),
                                child: CustomCard(
                                  title: d.title,
                                  imeiNumber: d.imei,
                                  onPressed: () {
                                    Get.to(
                                      () => DurationPage(deviceName: d.title),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
