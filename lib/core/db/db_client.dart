import 'dart:io';
import 'package:datav8/core/db/response_model.dart';
import 'package:datav8/core/network/connectivity_guard_service.dart';
import 'package:datav8/core/storage/auth_storage.dart';
import 'package:datav8/core/utils/snackbars.dart';
import 'package:datav8/features/auth/data/controller/auth_controller.dart';
import 'package:datav8/features/auth/presentation/login_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class DbClient extends GetxService {
  late Dio instance;
  bool _isHandlingAuthExpiry = false;

  void init() {
    instance = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 60),
      ),
    );
    instance.interceptors.add(
      LogInterceptor(responseBody: true, requestBody: true),
    );
    instance.interceptors.add(
      InterceptorsWrapper(
        onResponse: (response, handler) async {
          await _handleExpiredTokenPayloadIfAny(response.data);
          handler.next(response);
        },
        onError: (error, handler) async {
          await _handleExpiredTokenPayloadIfAny(error.response?.data);
          handler.next(error);
        },
      ),
    );
  }

  Future<ResponseModel<T?>> requestWrapper<T>(
    Future<ResponseModel<T?>> Function() run, {
    required String functionName,
  }) async {
    try {
      final connectivityGuard = Get.find<ConnectivityGuardService>();
      final isConnected = await connectivityGuard.hasInternetConnection();
      if (!isConnected) {
        await connectivityGuard.takeUserToNoInternetPage();
        return ResponseModel<T?>(false, 'No internet connection', null);
      }

      return await run();
    } on Map catch (e) {
      return ResponseModel<T?>(false, e['message'], null);
    } on DioException catch (e) {
      // Request cancellation is expected in flows like device switching.
      // Avoid noisy snackbars/logs for this case.
      if (e.type == DioExceptionType.cancel) {
        return ResponseModel<T?>(false, 'Request cancelled', null);
      }
      showErrorSnackbar('Error', e.toString(), functionName: functionName);
      debugPrint('[db_client.dart]: 🔥 EXCEPTION:: $e');
      return ResponseModel<T?>(false, e.toString(), null);
    } on SocketException catch (_) {
      return ResponseModel<T?>(false, 'Network error!', null);
    } catch (e) {
      if (e.toString().contains('AuthApiException') ||
          e.toString().contains('AuthWeakPasswordException')) {
        final message = e.toString().split('message: ')[1].split(',')[0];
        showErrorSnackbar('Error', message, functionName: functionName);
        debugPrint('[db_client.dart]: 🔥 EXCEPTION:: $e');
      } else {
        showErrorSnackbar('Error', e.toString(), functionName: functionName);
        debugPrint('[db_client.dart]: 🔥 EXCEPTION:: $e');
      }
      debugPrint('[db_client.dart]: 🔥 EXCEPTION:: $e');
      return ResponseModel<T?>(false, e.toString(), null);
    }
  }

  Future<void> _handleExpiredTokenPayloadIfAny(dynamic payload) async {
    if (_isHandlingAuthExpiry) return;
    if (payload is! Map) return;

    final status = '${payload['status'] ?? ''}'.trim().toLowerCase();
    final message = '${payload['message'] ?? ''}'.trim().toLowerCase();
    final isExpiredToken =
        status == 'failure' && message.contains('invalid imei token pair');
    if (!isExpiredToken) return;

    _isHandlingAuthExpiry = true;
    try {
      if (Get.isRegistered<AuthController>()) {
        await Get.find<AuthController>().logout();
        return;
      }
      if (Get.isRegistered<AuthStorage>()) {
        await Get.find<AuthStorage>().clearUser();
        await Get.find<AuthStorage>().clearCredentials();
      }
      Get.offAll(() => const LoginPage());
    } finally {
      _isHandlingAuthExpiry = false;
    }
  }
}
