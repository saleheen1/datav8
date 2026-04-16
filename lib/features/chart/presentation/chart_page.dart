import 'package:datav8/core/themes/custom_theme.dart';
import 'package:datav8/core/utils/text_utils.dart';
import 'package:datav8/core/utils/ui_const.dart';
import 'package:datav8/core/widgets/appbar_common.dart';
import 'package:datav8/core/widgets/custom_chart.dart';
import 'package:datav8/core/widgets/default_margin_widget.dart';
import 'package:datav8/core/widgets/loader_widget.dart';
import 'package:datav8/features/duration/data/chart_controller.dart';
import 'package:datav8/features/duration/data/model/chart_retrieve_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChartPage extends StatelessWidget {
  final String deviceName;
  final String duration;

  const ChartPage({
    super.key,
    required this.deviceName,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    final theme = CustomTheme.of(context);

    return GetBuilder<ChartController>(
      builder: (cc) {
        final payload = _chartPayload(cc.lastRetrieveData?.value);
        return LoaderWidget(
          isLoading: cc.isLoading,
          child: Scaffold(
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

                      // ListView.builder(
                      //   physics: NeverScrollableScrollPhysics(),
                      //   itemCount: 6,
                      //   shrinkWrap: true,
                      //   itemBuilder: (context, index) {
                      //     return Padding(
                      //       padding: const EdgeInsets.only(bottom: 30),
                      //       child: CustomChart(),
                      //     );
                      //   },
                      // ),
                      CustomChart(
                        samples: payload.samples,
                        timeLabels: payload.labels,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Rows oldest → newest; X axis uses [labels] (e.g. `HH:mm`).
({List<List<double?>>? samples, List<String>? labels}) _chartPayload(
  List<ChartRetrieveEntry>? value,
) {
  if (value == null || value.isEmpty) {
    return (samples: null, labels: null);
  }
  final sorted = List<ChartRetrieveEntry>.from(value)
    ..sort((a, b) {
      final ta = a.parsedTime;
      final tb = b.parsedTime;
      if (ta == null && tb == null) return 0;
      if (ta == null) return -1;
      if (tb == null) return 1;
      return ta.compareTo(tb);
    });
  return (
    samples: sorted
        .map((e) => [e.ch1, e.ch2, e.ch3, e.ch4, e.ch5])
        .toList(),
    labels: sorted.map((e) => _shortTimeLabel(e.time)).toList(),
  );
}

String _shortTimeLabel(String? time) {
  if (time == null || time.isEmpty) return '';
  final parts = time.split(' ');
  if (parts.length >= 2 && parts[1].length >= 5) {
    return parts[1].substring(0, 5);
  }
  return time;
}
