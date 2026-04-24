import 'package:datav8/core/db/api.dart';
import 'package:datav8/core/db/db_client.dart';
import 'package:datav8/core/db/response_model.dart';
import 'package:datav8/core/utils/parse_json_map.dart';
import 'package:get/get.dart';

class SetAlarmsRepo {
  final dbClient = Get.find<DbClient>();

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
