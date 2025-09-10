import 'package:datav8/core/themes/custom_theme.dart';
import 'package:datav8/core/utils/ui_const.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ButtonPrimary extends StatelessWidget {
  const ButtonPrimary({
    super.key,
    this.bgColor,
    required this.text,
    required this.onPressed,
    this.width,
    this.borderColor,
    this.textColor,
    this.icon,
    this.height,
    this.borderRadius,
    this.isLoading = false,
    this.textStyle,
    this.boxshadow = true,
  });

  final Color? bgColor;
  final String text;
  final VoidCallback onPressed;
  final double? width;
  final Color? borderColor;
  final Color? textColor;
  final Widget? icon;
  final double? height;
  final double? borderRadius;
  final bool isLoading;
  final TextStyle? textStyle;
  final bool boxshadow;

  @override
  Widget build(BuildContext context) {
    final theme = CustomTheme.of(context);
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(borderRadius ?? 100),
      child: Container(
        width: width ?? double.infinity,
        height: height ?? 45,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bgColor ?? theme.primary,
          boxShadow: boxshadow ? buttonShadow(context) : null,
          border: Border.all(color: borderColor ?? Colors.transparent),
          borderRadius: BorderRadius.circular(borderRadius ?? 100),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              SizedBox(
                height: 20,
                width: 20,
                child: const CircularProgressIndicator(color: Colors.white),
              )
            else
              Row(
                children: [
                  icon ?? Container(),
                  Text(
                    text,
                    style:
                        textStyle ??
                        TextStyle(
                          color: textColor ?? Colors.white,
                          fontSize: kIsWeb ? 13 : 14,
                          fontWeight: kIsWeb
                              ? FontWeight.w500
                              : FontWeight.w600,
                        ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
