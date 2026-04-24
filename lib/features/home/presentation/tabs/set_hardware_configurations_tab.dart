import 'package:datav8/core/themes/custom_theme.dart';
import 'package:datav8/core/utils/text_utils.dart';
import 'package:flutter/material.dart';

class SetHardwareConfigurationsTab extends StatelessWidget {
  const SetHardwareConfigurationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = CustomTheme.of(context);
    return Center(
      child: Text(
        'Set hardware configurations',
        style: TextUtils.b1Regular(context: context, color: theme.greyDark),
      ),
    );
  }
}
