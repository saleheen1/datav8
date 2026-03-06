import 'package:datav8/core/utils/text_utils.dart';
import 'package:flutter/material.dart';

class DurationCard extends StatelessWidget {
  final String title;
  const DurationCard({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: const Color(0x1D000000), width: 1),
      ),
      child: Center(
        child: Text(title, style: TextUtils.title2(context: context)),
      ),
    );
  }
}
