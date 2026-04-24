import 'package:datav8/core/db/api.dart';
import 'package:datav8/core/db/db_client.dart';
import 'package:datav8/core/db/response_model.dart';
import 'package:datav8/core/utils/parse_json_map.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class SetAlarmsRepo {
  final dbClient = Get.find<DbClient>();

  Future<ResponseModel<String?>> getChannelParam({
    required String imei,
    required String token,
    required int channel,
    required String param,
    CancelToken? cancelToken,
  }) async {
    return await dbClient.requestWrapper<String>(() async {
      final dioResponse = await dbClient.instance.post(
        Api.retrieve,
        cancelToken: cancelToken,
        data: {
          'imei': imei,
          'token': token,
          'op': 'get',
          'ch': '$channel',
          'param': param,
        },
      );

      final map = parseJsonMap(dioResponse.data);
      if (map == null) {
        return ResponseModel<String?>(false, 'Invalid get response', null);
      }

      final status = (map['status'] ?? '').toString().toLowerCase();
      final message = (map['message'] ?? '').toString();
      final value = (map['value'] ?? '').toString();
      final isSuccess = status == 'success';
      return ResponseModel<String?>(
        isSuccess,
        message.isNotEmpty ? message : status,
        isSuccess ? value : null,
      );
    }, functionName: 'getChannelParam');
  }

  Future<ResponseModel<bool?>> setChannelParam({
    required String imei,
    required String token,
    required int channel,
    required String param,
    required String value,
  }) async {
    return await dbClient.requestWrapper<bool>(() async {
      final dioResponse = await dbClient.instance.post(
        Api.retrieve,
        data: {
          'imei': imei,
          'token': token,
          'op': 'set',
          'ch': '$channel',
          'param': param,
          'value': value,
        },
      );

      final map = parseJsonMap(dioResponse.data);
      if (map != null) {
        final resultText = (map['result'] ?? '').toString().toLowerCase();
        final isFailure =
            resultText.contains('fail') || resultText.contains('error');
        return ResponseModel<bool?>(!isFailure, resultText, !isFailure);
      }

      final raw = (dioResponse.data ?? '').toString().toLowerCase();
      final isFailure = raw.contains('fail') || raw.contains('error');
      return ResponseModel<bool?>(!isFailure, raw, !isFailure);
    }, functionName: 'setChannelParam');
  }
}
