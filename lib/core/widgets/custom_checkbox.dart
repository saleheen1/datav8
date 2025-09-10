import 'package:datav8/core/themes/custom_theme.dart';
import 'package:datav8/core/utils/text_utils.dart';
import 'package:datav8/core/utils/ui_const.dart';
import 'package:flutter/material.dart';

class CustomCheckbox extends StatelessWidget {
  const CustomCheckbox({
    super.key,
    required this.onChanged,
    required this.title,
    this.subtitle,
    required this.value,
    this.showCheckAtEnd = false,
    this.showTwoCheckAtEnd = false,
    this.onSecondChanged,
    this.secondValue,
  });

  final Function(bool?)? onChanged;
  final String title;
  final String? subtitle;
  final bool value;
  final bool showCheckAtEnd;
  final bool showTwoCheckAtEnd;
  final Function(bool?)? onSecondChanged;
  final bool? secondValue;

  @override
  Widget build(BuildContext context) {
    final theme = CustomTheme.of(context);
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          if (!showCheckAtEnd && !showTwoCheckAtEnd) ...[
            _buildCheckbox(theme),
            gapW(1),
          ],
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.left,
              style: TextUtils.b1Regular(context: context),
            ),
          ),
          if (showCheckAtEnd && !showTwoCheckAtEnd) ...[
            gapW(1),
            _buildCheckbox(theme),
          ],
          if (showTwoCheckAtEnd) ...[
            gapW(1),
            _buildCheckbox(theme),
            gapW(15),
            _buildSecondCheckbox(theme),
          ],
        ],
      ),
    );
  }

  Widget _buildCheckbox(CustomThemeData theme) {
    return Checkbox(
      activeColor: theme.primary,
      checkColor: Colors.white,
      side: BorderSide(width: 1, color: Colors.black12.withOpacity(0.3)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: BorderSide(width: 1, color: Colors.black12.withOpacity(0.3)),
      ),
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _buildSecondCheckbox(CustomThemeData theme) {
    return Checkbox(
      activeColor: theme.primary,
      checkColor: Colors.white,
      side: BorderSide(width: 1, color: Colors.black12.withOpacity(0.3)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: BorderSide(width: 1, color: Colors.black12.withOpacity(0.3)),
      ),
      value: secondValue ?? false,
      onChanged: onSecondChanged,
    );
  }
}
