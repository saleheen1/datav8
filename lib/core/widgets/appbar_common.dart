import 'package:datav8/core/utils/text_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

appbarCommon(
  String title,
  BuildContext context, {
  bool hasBackButton = true,
  IconData? backIcon,
  bool centerTitle = true,
  actions,
  VoidCallback? onBackPressed,
  Widget? backButtonWidget,
  bool darkTheme = false,
  double? leadingWidth,
  bool showShadow = true,
}) {
  return PreferredSize(
    preferredSize: Size.fromHeight(60),
    child: AppBar(
      scrolledUnderElevation: 0.5,
      surfaceTintColor: Colors.transparent,
      shadowColor: showShadow ? Colors.black54 : Colors.transparent,
      centerTitle: centerTitle ? true : false,
      backgroundColor: darkTheme ? Colors.black : Colors.white,
      iconTheme: const IconThemeData(color: Colors.black),
      title: Text(
        title,
        style: TextUtils.title3(
          context: context,
          color: darkTheme ? Colors.white : Colors.black,
        ),
      ),
      elevation: .3,
      actions: actions,
      leadingWidth: leadingWidth ?? 55,
      leading: hasBackButton
          ? InkWell(
              onTap:
                  onBackPressed ??
                  () {
                    Get.back();
                  },
              child:
                  backButtonWidget ??
                  Icon(
                    backIcon ?? Icons.arrow_back_ios,
                    size: 20,
                    color: Colors.black,
                  ),
            )
          : Container(),
    ),
  );
}
