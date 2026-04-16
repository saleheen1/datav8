import 'dart:math';

import 'package:datav8/core/themes/custom_theme.dart';
import 'package:datav8/core/utils/text_utils.dart';
import 'package:datav8/core/utils/ui_const.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  static const List<List<Color>> _gradientPalettes = [
    [Color.fromARGB(255, 35, 189, 120), Color(0xFF62D6B1)], // green
    [Color.fromARGB(255, 75, 117, 223), Color(0xFF52C0FF)], // blue
    [Color.fromARGB(255, 125, 88, 193), Color(0xFFC38BFF)], // purple
    [Color.fromARGB(255, 198, 146, 33), Color(0xFFFFD35A)], // yellow
    [Color.fromARGB(255, 210, 98, 54), Color(0xFFFF915E)], // orange
  ];

  final String title;
  final String imeiNumber;
  final VoidCallback onPressed;
  const CustomCard({
    super.key,
    required this.onPressed,
    required this.title,
    required this.imeiNumber,
  });

  @override
  Widget build(BuildContext context) {
    final theme = CustomTheme.of(context);
    final gradientColors = _randomGradientColors();

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.only(left: 12, top: 16, bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: gradientColors,
                    ),
                    // borderRadius: BorderRadius.circular(10),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    title[0],
                    style: TextUtils.title2(
                      context: context,
                      color: Colors.white,
                    ),
                  ),
                ),
                gapW(13),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextUtils.title3(context: context)),
                    gapH(10),
                    Row(
                      children: [
                        Text(
                          'imei: ',
                          style: TextUtils.b1SemiBold(
                            context: context,
                            color: theme.greyDark,
                          ),
                        ),
                        Text(
                          imeiNumber,
                          style: TextUtils.b1Regular(
                            context: context,
                            color: theme.greyDark,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            IconButton(
              onPressed: onPressed,
              icon: Icon(
                Icons.arrow_forward_ios_rounded,
                color: theme.greyDark,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Color> _randomGradientColors() {
    if (_gradientPalettes.isEmpty) {
      return [Colors.blue, Colors.blueAccent];
    }
    // Deterministic random so list item color remains stable per card title.
    final random = Random(title.hashCode);
    return _gradientPalettes[random.nextInt(_gradientPalettes.length)];
  }
}
