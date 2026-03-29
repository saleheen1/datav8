import 'dart:io';
import 'package:datav8/core/db/response_model.dart';
import 'package:datav8/core/utils/snackbars.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class DbClient extends GetxService {
  late Dio instance;

  void init() {
    instance = Dio();
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
