import 'package:datav8/core/db/api.dart';
import 'package:datav8/core/db/db_client.dart';
import 'package:datav8/core/db/response_model.dart';
import 'package:datav8/core/utils/parse_json_map.dart';
import 'package:get/get.dart';

class DeleteOldDataRepo {
  final dbClient = Get.find<DbClient>();

  Future<ResponseModel<bool?>> deleteBeforeEpoch({
    required String imei,
    required String token,
    required int epochSeconds,
  }) async {
    return await dbClient.requestWrapper<bool>(() async {
      final response = await dbClient.instance.post(
        Api.retrieve,
        data: {
          'imei': imei,
          'token': token,
          'op': 'delete',
          'value': epochSeconds,
        },
      );

      final map = parseJsonMap(response.data);
      if (map != null) {
        final statusOrResult =
            (map['status'] ?? map['result'] ?? '').toString().toLowerCase();
        final message = (map['message'] ?? '').toString();
        final isSuccess =
            statusOrResult == 'success' || statusOrResult.contains('ok');
        return ResponseModel<bool?>(
          isSuccess,
          message.isNotEmpty ? message : statusOrResult,
          isSuccess,
        );
      }

      final raw = (response.data ?? '').toString().toLowerCase();
      final isFailure = raw.contains('fail') || raw.contains('error');
      return ResponseModel<bool?>(!isFailure, raw, !isFailure);
    }, functionName: 'deleteBeforeEpoch');
  }
}
