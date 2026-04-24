import 'package:datav8/core/utils/text_utils.dart';
import 'package:datav8/core/utils/ui_const.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HardwareChannelSectionSkeleton extends StatelessWidget {
  const HardwareChannelSectionSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Skeletonizer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Channel 1', style: TextUtils.title1Bold(context: context)),
            gapH(10),
            Text(
              'Upper Limit asdf adfdsf sfd',
              style: TextUtils.title1Bold(context: context),
            ),
            gapH(10),
            Text(
              'Channel 1 jhjhjhjhjhjhjhjhjhjjhjh',
              style: TextUtils.title1Bold(context: context),
            ),
            gapH(10),
            Text(
              'Channel 1hghhghghhghg',
              style: TextUtils.title1Bold(context: context),
            ),
          ],
        ),
      ),
    );
  }
}
