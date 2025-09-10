import 'package:datav8/core/themes/custom_theme.dart';
import 'package:datav8/core/widgets/show_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key, this.width, this.height, this.color});

  final double? width;
  final double? height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return ShowImage(
      imgLocation: "assets/images/logo.jpg",
      width: width ?? 220,
      height: height ?? 300,
      fit: BoxFit.fitWidth,
      isAssetImg: true,
    );
  }
}
