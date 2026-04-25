import 'package:datav8/core/storage/auth_storage.dart';
import 'package:datav8/features/home/data/model/device_access_level.dart';
import 'package:datav8/features/home/data/repo/device_access_repo.dart';
import 'package:get/get.dart';

class DeviceAccessController extends GetxController {
  final DeviceAccessRepo _repo = Get.find<DeviceAccessRepo>();
  final AuthStorage _authStorage = Get.find<AuthStorage>();

  final Map<String, DeviceAccessLevel> _levelsByImei = {};
  final Set<String> _loadingImeis = <String>{};

  DeviceAccessLevel levelForImei(String imei) {
    final key = imei.trim();
    if (key.isEmpty) return DeviceAccessLevel.viewOnly;
    return _levelsByImei[key] ?? DeviceAccessLevel.viewOnly;
  }

  bool isLoadingForImei(String imei) => _loadingImeis.contains(imei.trim());

  bool canSetAlarm(String imei) {
    final level = levelForImei(imei);
    return level == DeviceAccessLevel.alarmView ||
        level == DeviceAccessLevel.all;
  }

  bool canSetHardware(String imei) =>
      levelForImei(imei) == DeviceAccessLevel.all;
  bool canDeleteData(String imei) =>
      levelForImei(imei) == DeviceAccessLevel.all;

  void ensureAccessLoaded(String imei) {
    final key = imei.trim();
    if (key.isEmpty) return;
    if (_loadingImeis.contains(key)) return;
    if (_levelsByImei.containsKey(key)) return;
    _fetch(key);
  }

  Future<void> _fetch(String imei, {bool force = false}) async {
    if (_loadingImeis.contains(imei)) return;
    if (!force && _levelsByImei.containsKey(imei)) return;

    final token = _authStorage.readUser()?.token?.trim() ?? '';
    if (token.isEmpty) {
      _levelsByImei[imei] = DeviceAccessLevel.viewOnly;
      update();
      return;
    }

    _loadingImeis.add(imei);
    update();
    final response = await _repo.getAccessLevel(imei: imei, token: token);
    _loadingImeis.remove(imei);

    if (response.isSuccess && response.data != null) {
      _levelsByImei[imei] = DeviceAccessLevel.fromApiValue(response.data!);
    } else {
      _levelsByImei[imei] = DeviceAccessLevel.viewOnly;
    }
    update();
  }
}
