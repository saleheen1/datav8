import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:datav8/core/themes/custom_theme.dart';
import 'package:datav8/core/utils/text_utils.dart';

class AuthBottomText extends StatelessWidget {
  final String mainText;
  final String actionText;
  final VoidCallback onTap;
  final TextAlign textAlign;
  final Color? actionColor;

  const AuthBottomText({
    super.key,
    required this.mainText,
    required this.actionText,
    required this.onTap,
    this.textAlign = TextAlign.center,
    this.actionColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = CustomTheme.of(context);
    return RichText(
      textAlign: textAlign,
      text: TextSpan(
        text: mainText,
        style: TextUtils.b1Regular(context: context),
        children: [
          TextSpan(
            recognizer: TapGestureRecognizer()..onTap = onTap,
            text: actionText,
            style: TextUtils.b1SemiBold(
              context: context,
              color: actionColor ?? theme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
