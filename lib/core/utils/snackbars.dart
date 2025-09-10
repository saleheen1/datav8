import 'package:datav8/core/utils/text_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showSuccessSnackbar(String title, String message) {
  Get.snackbar(
    title,
    message,
    backgroundColor: Colors.white,
    animationDuration: const Duration(milliseconds: 600),
    boxShadows: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.2),
        blurRadius: 32,
        spreadRadius: 12,
      ),
    ],
    icon: Icon(Icons.check_circle, color: Colors.green[500]),
    colorText: Colors.green[500],
    margin: const EdgeInsets.only(top: 8, left: 8, right: 8),
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
    maxWidth: 400,
    titleText: Text(
      title,
      style: TextUtils.title3(
        context: Get.context!,
      ).copyWith(fontWeight: FontWeight.w600),
    ),
    messageText: Text(
      message,
      style: TextUtils.caption1(context: Get.context!),
    ),
    borderRadius: 5,
  );
}

void showErrorSnackbar(String title, String message) {
  Get.snackbar(
    title,
    message,
    backgroundColor: Colors.white,
    boxShadows: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.2),
        blurRadius: 32,
        spreadRadius: 12,
      ),
    ],
    animationDuration: const Duration(milliseconds: 600),
    icon: Icon(Icons.close, color: Colors.red[500]),
    colorText: Colors.red[500],
    margin: const EdgeInsets.only(top: 8, left: 8, right: 8),
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
    maxWidth: 400,
    titleText: Text(
      title,
      style: TextUtils.title3(
        context: Get.context!,
        color: Colors.red,
      ).copyWith(fontWeight: FontWeight.w600),
    ),
    messageText: Text(
      message,
      style: TextUtils.caption1(context: Get.context!, color: Colors.red),
    ),
    borderRadius: 5,
  );
}

showAlertSnackbar(String title, String message) {
  Get.snackbar(
    title,
    message,
    backgroundColor: Colors.white,
    animationDuration: const Duration(milliseconds: 600),
    icon: Icon(Icons.warning, color: Colors.orange[900]),
    colorText: Colors.orange[900],
    margin: const EdgeInsets.only(top: 8, left: 8, right: 8),
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
    maxWidth: 400,
    titleText: Text(
      title,
      style: TextUtils.title3(
        context: Get.context!,
        color: Colors.orange[900],
      ).copyWith(fontWeight: FontWeight.w600),
    ),
    messageText: Text(
      message,
      style: TextUtils.caption1(
        context: Get.context!,
        color: Colors.orange[900],
      ),
    ),
    borderRadius: 5,
  );
}
