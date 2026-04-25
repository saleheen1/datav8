import 'package:datav8/core/utils/snackbars.dart';
import 'package:datav8/features/home/data/controller/set_hardware_sensor_dropdown_controller.dart';
import 'package:datav8/features/home/data/repo/set_hardware_configurations_repo.dart';
import 'package:flutter/material.dart';

mixin SetHardwareConfigSaveMixin {
  SetHardwareConfigurationsRepo get hardwareConfigRepo;
  SetHardwareSensorDropdownController get sensorDropdownController;
  String? get selectedImeiRaw;
  String get authToken;
  void update([List<Object>? ids, bool condition = true]);

  List<bool> get isSavingChannel;
  bool get isSavingLoggerInfo;
  set isSavingLoggerInfo(bool value);
  List<bool> get channelInUse;
  List<TextEditingController> get channelNameControllers;
  TextEditingController get ownerController;
  TextEditingController get loggerNameController;
  TextEditingController get locationController;
  void saveCurrentConfigToCacheForSelectedDevice();

  Future<void> saveChannel(int index) async {
    if (isSavingChannel[index]) return;
    final token = authToken.trim();
    final imei = selectedImeiRaw?.trim() ?? '';
    if (token.isEmpty || imei.isEmpty) {
      showErrorSnackbar(
        'Save failed',
        'Missing selected device IMEI or token',
        functionName: 'saveHardwareChannel',
      );
      return;
    }

    final selectedSensor = sensorDropdownController.selectedForChannel(index);
    final sensorType = selectedSensor?.boardName ?? '';
    final channel = index + 1;
    final requests = [
      (
        channel: channel,
        param: 'channel_active',
        value: channelInUse[index] ? '1' : '0',
      ),
      (
        channel: channel,
        param: 'channel_name',
        value: channelNameControllers[index].text.trim(),
      ),
      (channel: channel, param: 'sensor_type', value: sensorType),
    ];

    isSavingChannel[index] = true;
    update();
    for (final req in requests) {
      final response = await hardwareConfigRepo.setParam(
        imei: imei,
        token: token,
        param: req.param,
        value: req.value,
        channel: req.channel,
      );
      if (!response.isSuccess) {
        isSavingChannel[index] = false;
        update();
        showErrorSnackbar(
          'Save failed',
          'Channel $channel - ${req.param}: ${response.message}',
          functionName: 'saveHardwareChannel',
        );
        return;
      }
    }
    isSavingChannel[index] = false;
    saveCurrentConfigToCacheForSelectedDevice();
    update();
    showSuccessSnackbar('Saved', 'Channel $channel hardware settings saved');
  }

  Future<void> saveLoggerInfo() async {
    if (isSavingLoggerInfo) return;
    final token = authToken.trim();
    final imei = selectedImeiRaw?.trim() ?? '';
    if (token.isEmpty || imei.isEmpty) {
      showErrorSnackbar(
        'Save failed',
        'Missing selected device IMEI or token',
        functionName: 'saveLoggerInfo',
      );
      return;
    }

    final requests = [
      (param: 'unit_owner', value: ownerController.text.trim()),
      (param: 'unit_name', value: loggerNameController.text.trim()),
      (param: 'unit_location', value: locationController.text.trim()),
    ];

    isSavingLoggerInfo = true;
    update();
    for (final req in requests) {
      final response = await hardwareConfigRepo.setParam(
        imei: imei,
        token: token,
        param: req.param,
        value: req.value,
      );
      if (!response.isSuccess) {
        isSavingLoggerInfo = false;
        update();
        showErrorSnackbar(
          'Save failed',
          '${req.param}: ${response.message}',
          functionName: 'saveLoggerInfo',
        );
        return;
      }
    }
    isSavingLoggerInfo = false;
    saveCurrentConfigToCacheForSelectedDevice();
    update();
    showSuccessSnackbar('Saved', 'Logger info saved');
  }
}
