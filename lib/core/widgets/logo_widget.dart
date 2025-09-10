import 'package:datav8/core/themes/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key, this.width, this.height, this.color});

  final double? width;
  final double? height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = CustomTheme.of(context);
    return SvgPicture.asset(
      "",
      width: width ?? 120,
      height: height ?? 120,
      colorFilter: ColorFilter.mode(color ?? theme.primary, BlendMode.srcIn),
    );
  }
}
