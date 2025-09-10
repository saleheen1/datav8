import 'package:datav8/core/themes/custom_theme.dart';
import 'package:datav8/core/utils/text_utils.dart';
import 'package:datav8/core/utils/ui_const.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDropDown extends StatelessWidget {
  const CustomDropDown({
    super.key,
    this.onChange,
    this.items,
    this.value,
    this.bgColor,
    this.borderColor,
    this.width,
    this.textStyle,
    this.icon,
    this.iconColor,
    this.borderRadius,
    this.dropDownTextColor,
    this.paddingV,
    this.readonly = false,
    this.label,
  });

  final Function(String?)? onChange;
  final List<String>? items;
  final String? value;
  final Color? bgColor;
  final Color? borderColor;
  final double? width;
  final Icon? icon;
  final Color? iconColor;
  final BorderRadius? borderRadius;
  final Color? dropDownTextColor;
  final TextStyle? textStyle;
  final double? paddingV;
  final bool readonly;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final theme = CustomTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label!, style: TextUtils.b1SemiBold(context: context)),
              gapH(12),
            ],
          ),
        Container(
          decoration: BoxDecoration(
            color: bgColor ?? theme.grey1,
            borderRadius: borderRadius ?? radiusCommon(),
          ),
          width: width ?? double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: 14,
            vertical: paddingV ?? 1,
          ),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              child: DropdownButton(
                borderRadius: BorderRadius.circular(2),
                icon: icon,
                onChanged: readonly ? null : onChange,
                iconDisabledColor: iconColor ?? const Color(0xffAAAAAA),
                iconEnabledColor: iconColor ?? const Color(0xffAAAAAA),
                dropdownColor: Colors.white,
                elevation: 2,
                isExpanded: true,
                value: value,
                items: items?.map((value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(
                      value.tr,
                      style: textStyle ?? TextUtils.b1Regular(context: context),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
