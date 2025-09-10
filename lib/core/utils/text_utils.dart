import 'package:datav8/core/themes/custom_theme.dart';
import 'package:flutter/material.dart';

class TextUtils {
  static TextStyle title1Bold({color, required context}) {
    return TextStyle(
      color: color ?? CustomTheme.of(context).black,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle title2({color, required context}) {
    return TextStyle(
      color: color ?? CustomTheme.of(context).black,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle title3({color, required context}) {
    return TextStyle(
      color: color ?? CustomTheme.of(context).black,
      fontSize: 14,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle b1Regular({color, required context}) {
    return TextStyle(
      color: color ?? CustomTheme.of(context).black,
      fontSize: 13,
    );
  }

  static TextStyle b1SemiBold({color, required context}) {
    return TextStyle(
      color: color ?? CustomTheme.of(context).black,
      fontSize: 13,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle caption1({color, required context}) {
    return TextStyle(
      color: color ?? CustomTheme.of(context).black,
      fontSize: 12,
    );
  }

  static TextStyle captionSemiBold({color, required context}) {
    return TextStyle(
      color: color ?? CustomTheme.of(context).black,
      fontSize: 12,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle b1Small({color, required context}) {
    return TextStyle(
      color: color ?? CustomTheme.of(context).black,
      fontSize: 10,
    );
  }
}
