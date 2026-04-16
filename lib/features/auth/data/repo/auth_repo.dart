import 'package:datav8/core/db/api.dart';
import 'package:datav8/core/db/db_client.dart';
import 'package:datav8/core/db/response_model.dart';
import 'package:datav8/core/utils/parse_json_map.dart';
import 'package:get/get.dart';

class AuthRepo {
  final dbClient = Get.find<DbClient>();

  Future<ResponseModel<Map<String, dynamic>?>> login(
    String email,
    String password,
  ) async {
    return await dbClient.requestWrapper<Map<String, dynamic>>(() async {
      final response = await dbClient.instance.post(
        Api.login,
        data: {"name": email, "pwd": password},
      );
      final map = parseJsonMap(response.data);
      if (map == null) {
        return ResponseModel<Map<String, dynamic>?>(
          false,
          'Unexpected response format',
          null,
        );
      }
      return ResponseModel<Map<String, dynamic>?>(
        true,
        'Login succeed',
        map,
      );
    }, functionName: 'login');
  }
}
