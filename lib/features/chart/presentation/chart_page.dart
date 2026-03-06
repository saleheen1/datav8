import 'package:datav8/core/themes/custom_theme.dart';
import 'package:datav8/core/utils/text_utils.dart';
import 'package:datav8/core/utils/ui_const.dart';
import 'package:datav8/core/widgets/appbar_common.dart';
import 'package:datav8/core/widgets/custom_chart.dart';
import 'package:datav8/core/widgets/default_margin_widget.dart';
import 'package:flutter/material.dart';

class ChartPage extends StatelessWidget {
  final String deviceName;
  final String duration;
  final String dateAndTime;

  const ChartPage({
    super.key,
    required this.deviceName,
    required this.duration,
    required this.dateAndTime,
  });

  @override
  Widget build(BuildContext context) {
    final theme = CustomTheme.of(context);

    return Scaffold(
      appBar: appbarCommon(deviceName, context),
      body: SingleChildScrollView(
        child: Container(
          color: theme.greyBg,
          width: double.infinity,
          child: DefaultMarginWidget(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                gapH(20),
                Text(duration, style: TextUtils.title2(context: context)),
                gapH(40),

                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 6,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: CustomChart(
                        dateAndTime: dateAndTime,
                        values: [100, 60, 80, 140, 100, 120],
                        labels: ['Ch1', 'Ch2', 'Ch3', 'Ch4', 'Ch5', 'Ch6'],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
