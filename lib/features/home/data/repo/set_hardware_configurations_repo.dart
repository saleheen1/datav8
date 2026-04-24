import 'package:datav8/core/db/api.dart';
import 'package:datav8/core/db/db_client.dart';
import 'package:datav8/core/db/response_model.dart';
import 'package:datav8/core/utils/parse_json_map.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class SetHardwareConfigurationsRepo {
  final dbClient = Get.find<DbClient>();

  Future<ResponseModel<String?>> getParam({
    required String imei,
    required String token,
    required String param,
    int? channel,
    CancelToken? cancelToken,
  }) async {
    return await dbClient.requestWrapper<String>(() async {
      final data = <String, dynamic>{
        'imei': imei,
        'token': token,
        'op': 'get',
        'param': param,
      };
      if (channel != null) {
        data['ch'] = '$channel';
      }

      final response = await dbClient.instance.post(
        Api.retrieve,
        data: data,
        cancelToken: cancelToken,
      );
      final map = parseJsonMap(response.data);
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
    }, functionName: 'hardwareGetParam');
  }

  Future<ResponseModel<bool?>> setParam({
    required String imei,
    required String token,
    required String param,
    required String value,
    int? channel,
  }) async {
    return await dbClient.requestWrapper<bool>(() async {
      final data = <String, dynamic>{
        'imei': imei,
        'token': token,
        'op': 'set',
        'param': param,
        'value': value,
      };
      if (channel != null) {
        data['ch'] = '$channel';
      }

      final response = await dbClient.instance.post(Api.retrieve, data: data);
      final map = parseJsonMap(response.data);
      if (map != null) {
        final resultText = (map['result'] ?? map['status'] ?? '')
            .toString()
            .toLowerCase();
        final isFailure =
            resultText.contains('fail') || resultText.contains('error');
        return ResponseModel<bool?>(!isFailure, resultText, !isFailure);
      }

      final raw = (response.data ?? '').toString().toLowerCase();
      final isFailure = raw.contains('fail') || raw.contains('error');
      return ResponseModel<bool?>(!isFailure, raw, !isFailure);
    }, functionName: 'hardwareSetParam');
  }
}
