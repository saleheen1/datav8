import 'package:datav8/features/home/data/controller/set_hardware_sensor_dropdown_controller.dart';
import 'package:datav8/features/home/data/repo/set_hardware_configurations_repo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

mixin SetHardwareConfigFetchMixin {
  int get totalChannels;
  SetHardwareConfigurationsRepo get hardwareConfigRepo;
  SetHardwareSensorDropdownController get sensorDropdownController;
  String? get selectedImeiRaw;
  String get authToken;
  void update([List<Object>? ids, bool condition = true]);

  bool get isLoadingConfig;
  set isLoadingConfig(bool value);
  bool get isLoggerInfoLoading;
  set isLoggerInfoLoading(bool value);
  bool get isLoggerInfoLoaded;
  set isLoggerInfoLoaded(bool value);
  List<bool> get isChannelConfigLoading;
  List<bool> get isChannelConfigLoaded;
  List<bool> get channelInUse;
  List<TextEditingController> get channelNameControllers;
  TextEditingController get ownerController;
  TextEditingController get loggerNameController;
  TextEditingController get locationController;

  int _loadRunId = 0;
  CancelToken? _activeLoadCancelToken;

  void cancelConfigLoading({bool notify = true}) {
    _activeLoadCancelToken?.cancel('Device changed');
    _activeLoadCancelToken = null;
    _loadRunId++;
    isLoadingConfig = false;
    isLoggerInfoLoading = false;
    isLoggerInfoLoaded = false;
    for (var i = 0; i < totalChannels; i++) {
      isChannelConfigLoading[i] = false;
      isChannelConfigLoaded[i] = false;
    }
    if (notify) update();
  }

  Future<void> loadSelectedDeviceConfig() async {
    cancelConfigLoading();
    final runId = _loadRunId;
    final token = authToken.trim();
    final imei = selectedImeiRaw?.trim() ?? '';
    if (token.isEmpty || imei.isEmpty) return;

    final cancelToken = CancelToken();
    _activeLoadCancelToken = cancelToken;
    if (sensorDropdownController.sensors.isEmpty) {
      await sensorDropdownController.fetchSensors();
    }

    isLoadingConfig = true;
    isLoggerInfoLoading = true;
    isLoggerInfoLoaded = false;
    for (var i = 0; i < totalChannels; i++) {
      isChannelConfigLoading[i] = false;
      isChannelConfigLoaded[i] = false;
    }
    update();

    Future<String?> getParam(String param, {int? channel}) async {
      final response = await hardwareConfigRepo.getParam(
        imei: imei,
        token: token,
        param: param,
        channel: channel,
        cancelToken: cancelToken,
      );
      if (!response.isSuccess) return null;
      return response.data;
    }

    final owner = await getParam('unit_owner');
    if (runId != _loadRunId) {
      isLoadingConfig = false;
      return;
    }
    final unitName = await getParam('unit_name');
    if (runId != _loadRunId) {
      isLoadingConfig = false;
      return;
    }
    final unitLocation = await getParam('unit_location');
    if (runId != _loadRunId) {
      isLoadingConfig = false;
      return;
    }

    ownerController.text = owner ?? '';
    loggerNameController.text = unitName ?? '';
    locationController.text = unitLocation ?? '';
    isLoggerInfoLoading = false;
    isLoggerInfoLoaded = true;
    update();

    for (var i = 0; i < totalChannels; i++) {
      final ch = i + 1;
      isChannelConfigLoading[i] = true;
      update();
      final active = await getParam('channel_active', channel: ch);
      if (runId != _loadRunId) {
        isLoadingConfig = false;
        return;
      }
      final channelName = await getParam('channel_name', channel: ch);
      if (runId != _loadRunId) {
        isLoadingConfig = false;
        return;
      }
      final sensorType = await getParam('sensor_type', channel: ch);
      if (runId != _loadRunId) {
        isLoadingConfig = false;
        return;
      }

      channelInUse[i] = (active ?? '0').trim() == '1';
      channelNameControllers[i].text = channelName ?? '';
      sensorDropdownController.setSelectedBySensorType(
        i,
        sensorType ?? '',
        notify: false,
      );
      isChannelConfigLoading[i] = false;
      isChannelConfigLoaded[i] = true;
      update();
    }

    sensorDropdownController.update();
    if (runId != _loadRunId) return;
    _activeLoadCancelToken = null;
    isLoadingConfig = false;
    update();
  }
}
