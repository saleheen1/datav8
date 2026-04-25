import 'package:datav8/core/db/db_client.dart';
import 'package:datav8/core/storage/auth_storage.dart';
import 'package:datav8/features/auth/data/controller/auth_controller.dart';
import 'package:datav8/features/auth/data/repo/auth_repo.dart';
import 'package:datav8/features/duration/data/chart_controller.dart';
import 'package:datav8/features/duration/data/controller/duration_pick_controller.dart';
import 'package:datav8/features/duration/data/repo/chart_repo.dart';
import 'package:datav8/features/home/data/controller/delete_old_data_controller.dart';
import 'package:datav8/features/home/data/controller/set_alarms_controller.dart';
import 'package:datav8/features/home/data/controller/set_hardware_configurations_controller.dart';
import 'package:datav8/features/home/data/controller/set_hardware_sensor_dropdown_controller.dart';
import 'package:datav8/features/home/data/repo/delete_old_data_repo.dart';
import 'package:datav8/features/home/data/repo/hardware_sensor_repo.dart';
import 'package:datav8/features/home/data/repo/set_alarms_repo.dart';
import 'package:datav8/features/home/data/repo/set_hardware_configurations_repo.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> initBindings() async {
  final prefs = await SharedPreferences.getInstance();
  Get.put(AuthStorage(prefs));

  final dbClient = Get.put(DbClient());
  dbClient.init();

  Get.lazyPut(() => AuthRepo(), fenix: true);
  Get.lazyPut(() => ChartRepo(), fenix: true);
  Get.lazyPut(() => DeleteOldDataRepo(), fenix: true);
  Get.lazyPut(() => SetAlarmsRepo(), fenix: true);
  Get.lazyPut(() => HardwareSensorRepo(), fenix: true);
  Get.lazyPut(() => SetHardwareConfigurationsRepo(), fenix: true);
  Get.put(AuthController());
  Get.put(DurationPickController());
  Get.put(ChartController());
  Get.lazyPut(() => DeleteOldDataController(), fenix: true);
  Get.lazyPut(() => SetAlarmsController(), fenix: true);
  Get.lazyPut(() => SetHardwareConfigurationsController(), fenix: true);
  Get.lazyPut(() => SetHardwareSensorDropdownController(), fenix: true);
}
