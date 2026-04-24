import 'package:datav8/core/themes/custom_theme.dart';
import 'package:datav8/core/utils/text_utils.dart';
import 'package:flutter/material.dart';

class DeleteOldDataTab extends StatelessWidget {
  const DeleteOldDataTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = CustomTheme.of(context);
    return Center(
      child: Text(
        'Delete old data',
        style: TextUtils.b1Regular(context: context, color: theme.greyDark),
      ),
    );
  }
}
