import 'package:datav8/core/themes/custom_theme.dart';
import 'package:datav8/core/utils/text_utils.dart';
import 'package:flutter/material.dart';

class DurationCard extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback? onTap;

  const DurationCard({
    super.key,
    required this.title,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = CustomTheme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(5),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: theme.border),
          ),
          child: Center(
            child: Text(
              title,
              style: TextUtils.b1SemiBold(context: context, color: theme.black),
            ),
          ),
        ),
      ),
    );
  }
}
