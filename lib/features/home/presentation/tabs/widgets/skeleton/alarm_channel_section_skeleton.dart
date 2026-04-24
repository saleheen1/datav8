import 'package:datav8/core/utils/text_utils.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AlarmChannelSectionSkeleton extends StatelessWidget {
  const AlarmChannelSectionSkeleton({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextUtils.title1Bold(context: context, color: Colors.black),
          ),
          const SizedBox(height: 15),
          Skeletonizer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Upper Limit asdf adfdsf sfd',
                  style: TextUtils.title1Bold(
                    context: context,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Lower Limit adfadf ',
                  style: TextUtils.title1Bold(context: context),
                ),
                const SizedBox(height: 10),
                Text(
                  'Alarm Holdoff',
                  style: TextUtils.title1Bold(
                    context: context,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Alarm Holdoff asdfdf',
                  style: TextUtils.title1Bold(
                    context: context,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
