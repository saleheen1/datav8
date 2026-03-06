import 'package:datav8/core/themes/custom_theme.dart';
import 'package:datav8/core/utils/text_utils.dart';
import 'package:datav8/core/utils/ui_const.dart';
import 'package:flutter/material.dart';

class CustomChart extends StatelessWidget {
  final String dateAndTime;
  final List<double> values;
  final List<String> labels;

  const CustomChart({
    super.key,
    required this.dateAndTime,
    required this.values,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    final theme = CustomTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //===================
        //Date and time
        //===================
        Text(dateAndTime, style: TextUtils.title3(context: context)),
        gapH(10),

        //===============================
        //Main graph/chart
        //===============================
        Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              left: BorderSide(color: Colors.black, width: 1),
              bottom: BorderSide(color: Colors.black, width: 1),
            ),
          ),
          child: Stack(
            children: [
              //======================
              //Red threshold line
              //======================
              Positioned(
                top: 20,
                left: 0,
                right: 0,
                child: Container(height: 1, color: theme.redLight),
              ),

              //========================
              // Chart area with bars starting from bottom (x-axis)
              //========================
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (double value in values)
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: 10,
                            height: value,
                            color: theme.greyDark,
                          ),
                        ),
                      ),

                    //=====================
                    //Blank values to have some wite space at the right
                    //=====================
                    for (int i = 0; i < 2; i++)
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: 10,
                            height: 0,
                            color: theme.greyDark,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),

        //===============================
        // Labels below the bottom border
        //===============================
        Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              for (String label in labels)
                Expanded(
                  child: Center(
                    child: Text(
                      label,
                      style: TextUtils.b1Regular(context: context),
                    ),
                  ),
                ),

              //=====================
              //Blank label to have some wite space at the right
              //=====================
              for (int i = 0; i < 2; i++)
                Expanded(child: Center(child: Text(''))),
            ],
          ),
        ),
      ],
    );
  }
}
