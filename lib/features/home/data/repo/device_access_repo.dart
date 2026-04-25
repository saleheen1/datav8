import 'package:datav8/core/db/api.dart';
import 'package:datav8/core/db/db_client.dart';
import 'package:datav8/core/db/response_model.dart';
import 'package:datav8/core/utils/parse_json_map.dart';
import 'package:get/get.dart';

class DeviceAccessRepo {
  final dbClient = Get.find<DbClient>();

  Future<ResponseModel<String?>> getAccessLevel({
    required String imei,
    required String token,
  }) async {
    return await dbClient.requestWrapper<String>(() async {
      final response = await dbClient.instance.post(
        Api.retrieve,
        data: {
          'imei': imei,
          'token': token,
          'op': 'get',
          'param': 'access_level',
        },
      );
      final map = parseJsonMap(response.data);
      if (map == null) {
        return ResponseModel<String?>(false, 'Invalid access response', null);
      }
      final status = '${map['status'] ?? ''}'.toLowerCase();
      final value = '${map['value'] ?? ''}';
      final message = '${map['message'] ?? ''}';
      final isSuccess = status == 'success';
      return ResponseModel<String?>(
        isSuccess,
        message.isNotEmpty ? message : status,
        isSuccess ? value : null,
      );
    }, functionName: 'getAccessLevel');
  }
}
