import 'package:datav8/core/themes/custom_theme.dart';
import 'package:datav8/core/utils/ui_const.dart';
import 'package:datav8/core/widgets/appbar_common.dart';
import 'package:datav8/core/widgets/custom_card.dart';
import 'package:datav8/core/widgets/default_margin_widget.dart';
import 'package:datav8/features/duration/presentation/duration_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = CustomTheme.of(context);

    return Scaffold(
      appBar: appbarCommon('Device list', hasBackButton: false, context),
      body: Container(
        color: theme.greyBg,
        child: Column(
          children: [
            DefaultMarginWidget(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  gapH(25),

                  CustomCard(
                    title: 'Cape town counter',
                    imeiNumber: '2342342352342141',
                    onPressed: () {
                      Get.to(DurationPage(deviceName: 'Cape town counter'));
                    },
                  ),
                  gapH(25),

                  CustomCard(
                    title: 'Samuel solar',
                    imeiNumber: '2342342352342141',
                    onPressed: () {
                      Get.to(DurationPage(deviceName: 'Samuel solar'));
                    },
                  ),
                  gapH(25),

                  CustomCard(
                    title: 'Starter kit',
                    imeiNumber: '2342342352342141',
                    onPressed: () {
                      Get.to(DurationPage(deviceName: 'Starter kit'));
                    },
                  ),
                  gapH(25),

                  CustomCard(
                    title: 'Another DataV8',
                    imeiNumber: '2342342352342141',
                    onPressed: () {
                      Get.to(DurationPage(deviceName: 'Another DataV8'));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
