import 'package:datav8/core/db/db_client.dart';
import 'package:datav8/core/db/response_model.dart';
import 'package:get/get.dart';

class AuthRepo {
  final dbClient = Get.find<DbClient>();

  Future<ResponseModel> login(String email, String password) async {
    return await dbClient.requestWrapper(() async {
      final response = await dbClient.instance.post(
        'auth/login',
        data: {"email": email, "password": password},
      );
      return ResponseModel(true, "Login succeed", response.data);
    }, functionName: 'login');
  }
}
