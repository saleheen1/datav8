import 'package:datav8/core/storage/auth_storage.dart';
import 'package:datav8/features/home/data/controller/mixin/set_alarms_device_mixin.dart';
import 'package:datav8/features/home/data/controller/mixin/set_alarms_fetch_mixin.dart';
import 'package:datav8/features/home/data/controller/mixin/set_alarms_form_mixin.dart';
import 'package:datav8/features/home/data/controller/mixin/set_alarms_save_mixin.dart';
import 'package:datav8/features/home/data/repo/set_alarms_repo.dart';
import 'package:get/get.dart';

class SetAlarmsController extends GetxController
    with
        SetAlarmsDeviceMixin,
        SetAlarmsFormMixin,
        SetAlarmsFetchMixin,
        SetAlarmsSaveMixin {
  static const int channelCount = 5;
  @override
  int get totalChannels => channelCount;
  @override
  final SetAlarmsRepo setAlarmsRepo = Get.find<SetAlarmsRepo>();
  @override
  final AuthStorage authStorage = Get.find<AuthStorage>();

  bool _isInitialized = false;

  void initializeForHome() {
    if (_isInitialized) return;
    _isInitialized = true;
    initDevices();
    initChannelFormState();
    initFetchState();
    loadSelectedDeviceAlarmConfig();
  }

  @override
  void onSelectedDeviceChanged() {
    loadSelectedDeviceAlarmConfig();
  }

  @override
  void onClose() {
    cancelAlarmConfigLoading(notify: false);
    disposeChannelControllers();
    super.onClose();
  }
}
