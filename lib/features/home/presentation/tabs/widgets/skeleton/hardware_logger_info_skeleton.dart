import 'package:datav8/core/utils/text_utils.dart';
import 'package:datav8/core/utils/ui_const.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HardwareLoggerInfoSkeleton extends StatelessWidget {
  const HardwareLoggerInfoSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 34),
      child: Skeletonizer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'IMEI: 000000000000000 jhjhj',
              style: TextUtils.title1Bold(context: context),
            ),
            gapH(20),
            Text(
              'IMEI: 000000000000000',
              style: TextUtils.title1Bold(context: context),
            ),
            gapH(12),
            Text(
              'IMEI: 000000000',
              style: TextUtils.title1Bold(context: context),
            ),
            gapH(12),
            Text(
              'IMEI: 000000000000000 jjhjhjh',
              style: TextUtils.title1Bold(context: context),
            ),
            gapH(24),
            Text(
              'IMEI: 000000000000000 jhjhjhjh',
              style: TextUtils.title1Bold(context: context),
            ),
          ],
        ),
      ),
    );
  }
}
