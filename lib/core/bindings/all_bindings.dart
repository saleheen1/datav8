import 'package:datav8/core/db/db_client.dart';
import 'package:datav8/core/storage/auth_storage.dart';
import 'package:datav8/features/auth/data/controller/auth_controller.dart';
import 'package:datav8/features/auth/data/repo/auth_repo.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> initBindings() async {
  final prefs = await SharedPreferences.getInstance();
  Get.put(AuthStorage(prefs));

  final dbClient = Get.put(DbClient());
  dbClient.init();

  Get.lazyPut(() => AuthRepo(), fenix: true);
  Get.put(AuthController());
}
