import 'package:datav8/core/themes/custom_theme.dart';
import 'package:datav8/core/utils/text_utils.dart';
import 'package:datav8/core/utils/ui_const.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final String imeiNumber;
  final VoidCallback onPressed;
  const CustomCard({
    super.key,
    required this.onPressed,
    required this.title,
    required this.imeiNumber,
  });

  @override
  Widget build(BuildContext context) {
    final theme = CustomTheme.of(context);

    return Container(
      padding: EdgeInsets.only(left: 16, top: 16, bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextUtils.title3(context: context),
              ),
              gapH(10),
              Row(
                children: [
                  Text('imei: ', style: TextUtils.b1SemiBold(context: context)),
                  Text(imeiNumber, style: TextUtils.b1Regular(context: context)),
                ],
              ),
            ],
          ),
          IconButton(
            onPressed: onPressed,
            icon: Icon(Icons.arrow_forward_ios_rounded, color: theme.greyDark),
          ),
        ],
      ),
    );
  }
}
