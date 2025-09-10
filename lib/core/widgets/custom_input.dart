import 'package:datav8/core/themes/custom_theme.dart';
import 'package:datav8/core/utils/text_utils.dart';
import 'package:datav8/core/utils/ui_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomInput extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final Function(String)? onChanged;
  final VoidCallback? onTap;
  final VoidCallback? onSuffixTap;
  final bool? readOnly;
  final String? Function(String?)? validation;
  final TextInputAction textInputAction;
  final bool isPasswordField;
  final FocusNode? focusNode;
  final bool isNumberField;
  final Widget? prefixIcon;
  final String? suffixIcon;
  final double? paddingVertical;
  final double marginBottom;
  final BorderRadius? borderRadius;
  final TextEditingController? controller;
  final Color? bgColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final int? maxLines;
  final bool autofocus;
  final double? inputHeight;
  final Function(String)? onFieldSubmitted;
  final EdgeInsets? scrollPadding;

  const CustomInput({
    super.key,
    this.hintText,
    this.labelText,
    this.onChanged,
    this.textInputAction = TextInputAction.next,
    this.isPasswordField = false,
    this.focusNode,
    this.isNumberField = false,
    this.controller,
    this.validation,
    this.prefixIcon,
    this.suffixIcon,
    this.marginBottom = 0,
    this.borderRadius,
    this.paddingVertical,
    this.bgColor,
    this.maxLines,
    this.onTap,
    this.readOnly,
    this.autofocus = false,
    this.inputHeight,
    this.onSuffixTap,
    this.onFieldSubmitted,
    this.borderColor,
    this.focusedBorderColor,
    this.scrollPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null)
          Container(
            margin: EdgeInsets.only(bottom: 12),
            child: Text(
              labelText!,
              style: TextUtils.b1SemiBold(context: context),
            ),
          ),

        //input
        Container(
          margin: EdgeInsets.only(bottom: marginBottom),
          child: Theme(
            data: Theme.of(context).copyWith(
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: TextFormField(
              controller: controller,
              contextMenuBuilder:
                  (BuildContext context, EditableTextState editableTextState) {
                    if (SystemContextMenu.isSupported(context)) {
                      return SystemContextMenu.editableText(
                        editableTextState: editableTextState,
                      );
                    }
                    return AdaptiveTextSelectionToolbar.editableText(
                      editableTextState: editableTextState,
                    );
                  },
              scrollPadding: scrollPadding ?? const EdgeInsets.all(0),
              autofocus: autofocus,
              keyboardType: isNumberField
                  ? TextInputType.number
                  : TextInputType.text,
              focusNode: focusNode,
              onFieldSubmitted: onFieldSubmitted,
              maxLines: maxLines ?? 1,
              onChanged: onChanged,
              onTap: onTap,
              validator: validation,
              textInputAction: textInputAction,
              obscureText: isPasswordField,
              readOnly: readOnly ?? false,
              style: TextUtils.b1Regular(context: context),
              decoration: customInputDecoration(
                context,
                prefixIcon: prefixIcon,
                suffixIcon: suffixIcon,
                bgColor: bgColor,
                borderRadius: borderRadius,
                hintText: hintText,
                paddingVertical: paddingVertical,
                onSuffixTap: onSuffixTap,
                borderColor: borderColor,
                focusedBorderColor: focusedBorderColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

InputDecoration customInputDecoration(
  BuildContext context, {
  Widget? prefixIcon,
  VoidCallback? onSuffixTap,
  bgColor,
  BorderRadius? borderRadius,
  String? hintText,
  double? paddingVertical,
  suffixIcon,
  borderColor,
  focusedBorderColor,
}) {
  final theme = CustomTheme.of(context);

  return InputDecoration(
    prefixIcon: prefixIcon != null
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [prefixIcon],
          )
        : null,
    suffixIcon: suffixIcon != null
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: onSuffixTap,
                child: SvgPicture.asset(suffixIcon!, height: 25),
              ),
            ],
          )
        : null,
    fillColor: bgColor ?? CustomTheme.of(context).grey1,
    border: InputBorder.none,
    filled: true,
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: focusedBorderColor ?? theme.primary),
      borderRadius: borderRadius ?? radiusCommon(),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: radiusCommon(),
      borderSide: BorderSide(color: theme.warningRed),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: theme.warningRed),
      borderRadius: radiusCommon(),
    ),
    hintText: hintText,
    hintStyle: TextUtils.b1Regular(context: context, color: theme.placeholder),
    contentPadding: EdgeInsets.symmetric(
      horizontal: 16,
      vertical:
          paddingVertical ??
          (prefixIcon != null || suffixIcon != null ? 12 : 0),
    ),
  );
}
