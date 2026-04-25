import 'package:datav8/core/utils/text_utils.dart';
import 'package:datav8/core/utils/ui_const.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DropdownSavingSkeleton extends StatelessWidget {
  const DropdownSavingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Please wait while we save the channel data',
          style: TextUtils.b1Regular(context: context),
        ),
        gapH(10),
        Skeletonizer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Saving selected device...',
                style: TextUtils.title1Bold(context: context),
              ),
              gapH(3),
              Text(
                'Dropdown is temporarily disabled',
                style: TextUtils.title1Bold(context: context),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
