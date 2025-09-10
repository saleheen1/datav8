import 'package:flutter/material.dart';

class DefaultMarginWidget extends StatelessWidget {
  const DefaultMarginWidget({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    double margin = 15;

    return Container(
      clipBehavior: Clip.none,
      margin: EdgeInsets.symmetric(horizontal: margin),
      child: child,
    );
  }
}
