// import 'package:get/get.dart';

import 'package:datav8/core/db/db_client.dart';
import 'package:datav8/features/auth/data/controller/login_controller.dart';
import 'package:datav8/features/auth/data/repo/auth_repo.dart';
import 'package:get/get.dart';

Future<void> initBindings() async {
  final dbClient = Get.put(DbClient());
  dbClient.init();

  Get.lazyPut(() => AuthRepo(), fenix: true);
  Get.put(LoginController());
}
