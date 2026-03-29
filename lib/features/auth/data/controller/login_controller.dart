import 'package:datav8/core/utils/snackbars.dart';
import 'package:datav8/features/home/presentation/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'mixin/login_validation_mixin.dart';
import '../repo/auth_repo.dart';

class LoginController extends GetxController with LoginValidationMixin {
  final AuthRepo authRepo = Get.find<AuthRepo>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  setLoading(bool value) {
    isLoading = value;
    update();
  }

  Future<bool> login() async {
    if (isLoading) return false;
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (!validateCredentials(email, password)) {
      return false;
    }

    setLoading(true);
    final response = await authRepo.login(email, password);
    if (response.isSuccess) {
      Get.offAll(() => HomePage());
      return true;
    }

    showErrorSnackbar('Login failed', response.message, functionName: 'login');
    setLoading(false);
    return false;
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
