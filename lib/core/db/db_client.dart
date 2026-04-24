import 'dart:io';
import 'package:datav8/core/db/response_model.dart';
import 'package:datav8/core/utils/snackbars.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class DbClient extends GetxService {
  late Dio instance;

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
  }

  Future<ResponseModel<T?>> requestWrapper<T>(
    Future<ResponseModel<T?>> Function() run, {
    required String functionName,
  }) async {
    try {
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
}
