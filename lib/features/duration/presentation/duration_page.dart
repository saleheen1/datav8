import 'package:datav8/core/themes/custom_theme.dart';
import 'package:datav8/core/utils/ui_const.dart';
import 'package:datav8/core/widgets/appbar_common.dart';
import 'package:datav8/core/widgets/button_primary.dart';
import 'package:datav8/core/widgets/default_margin_widget.dart';
import 'package:datav8/core/widgets/duration_card.dart';
import 'package:datav8/features/chart/presentation/chart_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class DurationPage extends StatelessWidget {
  final String deviceName;
  const DurationPage({super.key, required this.deviceName});

  @override
  Widget build(BuildContext context) {
    final theme = CustomTheme.of(context);
    return Scaffold(
      appBar: appbarCommon(deviceName, context),
      body: Container(
        color: theme.greyBg,
        child: DefaultMarginWidget(
          child: Column(
            children: [
              //=====================================
              //Duration Button
              //=====================================
              gapH(35),
              MasonryGridView.count(
                crossAxisCount: 2,
                itemCount: 3,
                shrinkWrap: true,
                mainAxisSpacing: 25,
                crossAxisSpacing: 25,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return DurationCard(title: 'Last 24h');
                },
              ),
              gapH(40),

              //=========================
              //Time picker
              //=========================
              Row(
                children: [
                  Text('Start time:'),
                  gapW(30),
                  ButtonPrimary(
                    text: 'Pick a time',
                    width: 130,
                    borderRadius: 5,
                    height: 35,
                    onPressed: () {},
                    boxshadow: false,
                  ),
                ],
              ),
              gapH(20),
              Row(
                children: [
                  Text('End time:  '),
                  gapW(30),
                  ButtonPrimary(
                    text: 'Pick a time',
                    width: 130,
                    borderRadius: 5,
                    height: 35,
                    onPressed: () {},
                    boxshadow: false,
                  ),
                ],
              ),

              //=========================
              //Seeing the graph button
              //=========================
              gapH(45),
              ButtonPrimary(
                text: 'Next',
                onPressed: () {
                  Get.to(
                    ChartPage(
                      deviceName: deviceName,
                      duration: 'Last 24 hours',
                      dateAndTime: '2023-05-03 10:21:33',
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
