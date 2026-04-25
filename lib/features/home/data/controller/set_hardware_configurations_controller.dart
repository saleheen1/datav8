import 'package:datav8/core/storage/auth_storage.dart';
import 'package:datav8/features/home/data/controller/mixin/set_hardware_config_device_mixin.dart';
import 'package:datav8/features/home/data/controller/mixin/set_hardware_config_fetch_mixin.dart';
import 'package:datav8/features/home/data/controller/mixin/set_hardware_config_form_mixin.dart';
import 'package:datav8/features/home/data/controller/mixin/set_hardware_config_save_mixin.dart';
import 'package:datav8/features/home/data/controller/set_hardware_sensor_dropdown_controller.dart';
import 'package:datav8/features/home/data/repo/set_hardware_configurations_repo.dart';
import 'package:get/get.dart';

class SetHardwareConfigurationsController extends GetxController
    with
        SetHardwareConfigDeviceMixin,
        SetHardwareConfigFormMixin,
        SetHardwareConfigFetchMixin,
        SetHardwareConfigSaveMixin {
  static const int channelCount = 5;

  @override
  final AuthStorage authStorage = Get.find<AuthStorage>();
  @override
  final SetHardwareConfigurationsRepo hardwareConfigRepo =
      Get.find<SetHardwareConfigurationsRepo>();
  @override
  final SetHardwareSensorDropdownController sensorDropdownController =
      Get.find<SetHardwareSensorDropdownController>();

  static const List<String> slotDropdownLabels = [
    'Select Measurement Module in leftmost slot',
    'Select Measurement Module in second from left slot',
    'Select Measurement Module in middle slot',
    'Select Measurement Module in second from right slot',
    'Select Measurement Module in rightmost slot',
  ];

  @override
  int get totalChannels => channelCount;
  @override
  String get authToken => authStorage.readUser()?.token?.trim() ?? '';

  bool _isInitialized = false;

  void initializeForHome() {
    if (_isInitialized) return;
    _isInitialized = true;
    initDevices();
    initFormState();
    Future.microtask(loadSelectedDeviceConfig);
  }

  @override
  void onSelectedDeviceChanged() {
    loadSelectedDeviceConfig();
  }

  @override
  void onClose() {
    cancelConfigLoading(notify: false);
    disposeFormControllers();
    super.onClose();
  }
}
