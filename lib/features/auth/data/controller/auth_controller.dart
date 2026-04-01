import 'package:datav8/core/storage/auth_storage.dart';
import 'package:datav8/core/utils/snackbars.dart';
import 'package:datav8/features/auth/data/model/user_data_model.dart';
import 'package:datav8/features/auth/presentation/login_page.dart';
import 'package:datav8/features/home/presentation/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'mixin/login_validation_mixin.dart';
import '../repo/auth_repo.dart';

class AuthController extends GetxController with LoginValidationMixin {
  final AuthRepo authRepo = Get.find<AuthRepo>();
  final AuthStorage _authStorage = Get.find<AuthStorage>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  setLoading(bool value) {
    isLoading = value;
    update();
  }

  //=================================
  //Login
  //=================================
  UserDataModel? userData;

  bool get isLoggedIn {
    final t = userData?.token;
    return t != null && t.isNotEmpty;
  }

  Future<void> restoreSessionIfAny() async {
    final saved = _authStorage.readUser();
    final token = saved?.token;
    if (saved != null && token != null && token.isNotEmpty) {
      userData = saved;
      update();
    }
  }

  Future<void> logout() async {
    await _authStorage.clearUser();
    userData = null;
    update();
    Get.offAll(() => const LoginPage());
  }

  //=================================

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
      final raw = response.data;
      if (raw == null) {
        showErrorSnackbar(
          'Login failed',
          'Unexpected response format',
          functionName: 'login',
        );
        setLoading(false);
        update();
        return false;
      }
      userData = UserDataModel.fromJson(raw);
      await _authStorage.saveUser(userData!);
      setLoading(false);
      update();
      Get.offAll(() => const HomePage());
      return true;
    }

    showErrorSnackbar('Login failed', response.message, functionName: 'login');
    setLoading(false);
    update();
    return false;
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
