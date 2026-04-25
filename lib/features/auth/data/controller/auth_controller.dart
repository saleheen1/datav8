import 'package:datav8/core/storage/auth_storage.dart';
import 'package:datav8/core/db/response_model.dart';
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
    userData = null;
    // Always perform a fresh login on app launch to sync latest server data.
    await loginWithSavedCredentials(silent: true);
  }

  Future<void> logout() async {
    await _authStorage.clearUser();
    await _authStorage.clearCredentials();
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
    return await _completeLogin(
      response: response,
      email: email,
      password: password,
      navigateToHome: true,
      showFailureSnackbar: true,
    );
  }

  Future<bool> loginWithSavedCredentials({bool silent = false}) async {
    if (isLoading) return false;
    final credentials = await _authStorage.readCredentials();
    if (credentials == null) return false;

    setLoading(!silent);
    final response = await authRepo.login(
      credentials.email,
      credentials.password,
    );
    return await _completeLogin(
      response: response,
      email: credentials.email,
      password: credentials.password,
      navigateToHome: false,
      showFailureSnackbar: !silent,
    );
  }

  Future<bool> _completeLogin({
    required ResponseModel<Map<String, dynamic>?> response,
    required String email,
    required String password,
    required bool navigateToHome,
    required bool showFailureSnackbar,
  }) async {
    if (response.isSuccess) {
      final raw = response.data;
      if (raw == null) {
        if (showFailureSnackbar) {
          showErrorSnackbar(
            'Login failed',
            'Unexpected response format',
            functionName: 'login',
          );
        }
        setLoading(false);
        update();
        return false;
      }
      userData = UserDataModel.fromJson(raw);
      await _authStorage.saveUser(userData!);
      await _authStorage.saveCredentials(email: email, password: password);
      setLoading(false);
      update();
      if (navigateToHome) {
        Get.offAll(() => const HomePage());
      }
      return true;
    }

    if (showFailureSnackbar) {
      showErrorSnackbar('Login failed', response.message, functionName: 'login');
    }
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
