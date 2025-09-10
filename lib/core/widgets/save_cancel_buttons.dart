import 'package:datav8/core/themes/custom_theme.dart';
import 'package:flutter/material.dart';
import 'button_primary.dart';

class SaveCancelButtons extends StatelessWidget {
  final String leftButtonText;
  final String rightButtonText;
  final VoidCallback onLeftPressed;
  final VoidCallback onRightPressed;
  final Color? leftBgColor;
  final Color? leftTextColor;
  final Color? leftBorderColor;
  final Color? rightBgColor;
  final Color? rightTextColor;
  final Color? rightBorderColor;
  final double gap;

  const SaveCancelButtons({
    super.key,
    required this.leftButtonText,
    required this.rightButtonText,
    required this.onLeftPressed,
    required this.onRightPressed,
    this.leftBgColor,
    this.leftTextColor,
    this.leftBorderColor,
    this.rightBgColor,
    this.rightTextColor,
    this.rightBorderColor,
    this.gap = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = CustomTheme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: ButtonPrimary(
            text: leftButtonText,
            bgColor: leftBgColor ?? Colors.transparent,
            textColor: leftTextColor ?? theme.greyDark,
            borderColor: leftBorderColor ?? theme.greyDark,
            onPressed: onLeftPressed,
            boxshadow: false,
          ),
        ),
        SizedBox(width: gap),
        Expanded(
          child: ButtonPrimary(
            text: rightButtonText,
            bgColor: rightBgColor,
            textColor: rightTextColor,
            borderColor: rightBorderColor,
            onPressed: onRightPressed,
          ),
        ),
      ],
    );
  }
}
