import 'package:datav8/core/helper/common_helper.dart';
import 'package:datav8/core/utils/ui_const.dart';
import 'package:flutter/material.dart';

class CommonPopupWidget extends StatelessWidget {
  const CommonPopupWidget({
    super.key,
    required this.popupContent,
    this.dialogHeight,
  });

  final Widget popupContent;
  final double? dialogHeight;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(16);

    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.all(15),
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      child: GestureDetector(
        onTap: () {
          hideKeyboard(context);
        },
        child: SizedBox(
          height: dialogHeight,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Close button
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    margin: EdgeInsets.only(top: 5, right: 10),
                    child: IconButton(
                      icon: const Icon(Icons.close, size: 24),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
                gapH(8),
                Container(
                  padding: EdgeInsets.only(
                    left: 25,
                    right: 25,
                    top: 0,
                    bottom: 25,
                  ),
                  child: popupContent,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
