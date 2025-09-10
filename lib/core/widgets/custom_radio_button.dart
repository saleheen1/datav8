import 'package:datav8/core/themes/custom_theme.dart';
import 'package:datav8/core/utils/text_utils.dart';
import 'package:flutter/material.dart';

class CustomRadioButton<T> extends StatelessWidget {
  final String title;
  final String? subtitle;
  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final bool isSelected;
  final Color? selectedColor;
  final Color? unselectedColor;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final EdgeInsetsGeometry? contentPadding;
  final Widget? leading;
  final Widget? trailing;

  const CustomRadioButton({
    super.key,
    required this.title,
    this.subtitle,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.isSelected = false,
    this.selectedColor,
    this.unselectedColor,
    this.titleStyle,
    this.subtitleStyle,
    this.contentPadding,
    this.leading,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = CustomTheme.of(context);
    return RadioListTile<T>(
      title: Text(
        title,
        style:
            titleStyle ??
            TextUtils.b1SemiBold(context: context, color: theme.black),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style:
                  subtitleStyle ??
                  TextUtils.b1Regular(context: context, color: theme.greyDark),
            )
          : null,
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      activeColor: selectedColor ?? theme.primary,
      contentPadding:
          contentPadding ??
          const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      controlAffinity: ListTileControlAffinity.leading,
      secondary: trailing,
    );
  }
}
