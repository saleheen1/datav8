import 'package:datav8/core/themes/custom_theme.dart';
import 'package:datav8/core/utils/ui_const.dart';
import 'package:datav8/core/widgets/appbar_common.dart';
import 'package:datav8/core/widgets/custom_card.dart';
import 'package:datav8/core/widgets/default_margin_widget.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

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
                    onPressed: () {},
                  ),
                  gapH(25),

                  CustomCard(
                    title: 'Cape town counter',
                    imeiNumber: '2342342352342141',
                    onPressed: () {},
                  ),
                  gapH(25),

                  CustomCard(
                    title: 'Cape town counter',
                    imeiNumber: '2342342352342141',
                    onPressed: () {},
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
