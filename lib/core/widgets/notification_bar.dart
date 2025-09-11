import 'package:flutter/material.dart';

class NotificationBar extends StatelessWidget {
  const NotificationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).padding.top,
      width: double.infinity,
      color: Colors.white,
    );
  }
}