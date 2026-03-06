import 'package:flutter/material.dart';

class CustomThemeData {
  final Color primary;
  final Color black;
  final Color grey1;
  final Color greyDark;
  final Color greyBg;
  final Color warningRed;
  final Color placeholder;
  final Color border;
  final Color badgeBg;
  final Color badgeText;
  final Color orangeColor;
  final Color redLight;

  CustomThemeData({
    required this.primary,
    required this.black,
    required this.grey1,
    required this.greyDark,
    required this.greyBg,
    required this.warningRed,
    required this.placeholder,
    required this.border,
    required this.badgeBg,
    required this.badgeText,
    required this.orangeColor,
    required this.redLight
  });
}

class CustomTheme extends InheritedWidget {
  final CustomThemeData customThemeData;

  const CustomTheme({
    super.key,
    required this.customThemeData,
    required super.child,
  });

  static CustomThemeData of(BuildContext context) {
    final CustomTheme? customTheme = context
        .dependOnInheritedWidgetOfExactType<CustomTheme>();
    return customTheme!.customThemeData;
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}

// ::test to make theme accessing shorter and normal way insead of CustomTheme.of()
extension ThemeExtender on ThemeData {
  Color get myColor =>
      brightness == Brightness.dark ? Colors.black : Colors.white;
}
