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
  final Map<String, _HardwareConfigDeviceCache> _deviceConfigCache = {};

  void clearHardwareConfigCache() {
    _deviceConfigCache.clear();
    isLoadingConfig = false;
    isLoggerInfoLoading = false;
    isLoggerInfoLoaded = false;
    for (var i = 0; i < totalChannels; i++) {
      isChannelConfigLoading[i] = false;
      isChannelConfigLoaded[i] = false;
    }
  }

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
    _applyCachedConfig(imei);
    final shouldLoadLoggerInfo = !isLoggerInfoLoaded;

    final cancelToken = CancelToken();
    _activeLoadCancelToken = cancelToken;
    if (sensorDropdownController.sensors.isEmpty) {
      await sensorDropdownController.fetchSensors();
    }

    isLoadingConfig = true;
    isLoggerInfoLoading = shouldLoadLoggerInfo;
    for (var i = 0; i < totalChannels; i++) {
      isChannelConfigLoading[i] = false;
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

    if (shouldLoadLoggerInfo) {
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
      isLoggerInfoLoaded = owner != null && unitName != null && unitLocation != null;
      if (isLoggerInfoLoaded) {
        _saveCurrentToCache(imei);
      }
      update();
    }

    for (var i = 0; i < totalChannels; i++) {
      if (isChannelConfigLoaded[i]) continue;
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
      isChannelConfigLoaded[i] =
          active != null && channelName != null && sensorType != null;
      if (isChannelConfigLoaded[i]) {
        _saveCurrentToCache(imei);
      }
      update();
    }

    sensorDropdownController.update();
    if (runId != _loadRunId) return;
    _activeLoadCancelToken = null;
    isLoadingConfig = false;
    _saveCurrentToCache(imei);
    update();
  }

  void saveCurrentConfigToCacheForSelectedDevice() {
    final imei = selectedImeiRaw?.trim() ?? '';
    if (imei.isEmpty) return;
    _saveCurrentToCache(imei);
  }

  void _applyCachedConfig(String imei) {
    final cached = _deviceConfigCache[imei];
    if (cached == null) {
      isLoggerInfoLoaded = false;
      for (var i = 0; i < totalChannels; i++) {
        isChannelConfigLoaded[i] = false;
      }
      return;
    }

    if (cached.isLoggerInfoLoaded) {
      ownerController.text = cached.owner;
      loggerNameController.text = cached.loggerName;
      locationController.text = cached.location;
      isLoggerInfoLoaded = true;
      isLoggerInfoLoading = false;
    } else {
      isLoggerInfoLoaded = false;
    }

    for (var i = 0; i < totalChannels; i++) {
      final loaded = cached.channelLoaded[i];
      isChannelConfigLoaded[i] = loaded;
      if (!loaded) continue;
      channelInUse[i] = cached.channelInUse[i];
      channelNameControllers[i].text = cached.channelNames[i];
      sensorDropdownController.setSelectedBySensorType(
        i,
        cached.sensorTypes[i],
        notify: false,
      );
    }

    sensorDropdownController.update();
    update();
  }

  void _saveCurrentToCache(String imei) {
    final existing = _deviceConfigCache[imei];
    final channelLoaded = existing != null
        ? List<bool>.from(existing.channelLoaded)
        : List<bool>.filled(totalChannels, false);
    final channelUse = existing != null
        ? List<bool>.from(existing.channelInUse)
        : List<bool>.filled(totalChannels, true);
    final channelNames = existing != null
        ? List<String>.from(existing.channelNames)
        : List<String>.filled(totalChannels, '');
    final sensorTypes = existing != null
        ? List<String>.from(existing.sensorTypes)
        : List<String>.filled(totalChannels, '');

    for (var i = 0; i < totalChannels; i++) {
      if (!isChannelConfigLoaded[i]) continue;
      channelLoaded[i] = true;
      channelUse[i] = channelInUse[i];
      channelNames[i] = channelNameControllers[i].text.trim();
      sensorTypes[i] =
          sensorDropdownController.selectedForChannel(i)?.boardName ?? '';
    }

    _deviceConfigCache[imei] = _HardwareConfigDeviceCache(
      isLoggerInfoLoaded: isLoggerInfoLoaded,
      owner: ownerController.text.trim(),
      loggerName: loggerNameController.text.trim(),
      location: locationController.text.trim(),
      channelLoaded: channelLoaded,
      channelInUse: channelUse,
      channelNames: channelNames,
      sensorTypes: sensorTypes,
    );
  }
}

class _HardwareConfigDeviceCache {
  _HardwareConfigDeviceCache({
    required this.isLoggerInfoLoaded,
    required this.owner,
    required this.loggerName,
    required this.location,
    required this.channelLoaded,
    required this.channelInUse,
    required this.channelNames,
    required this.sensorTypes,
  });

  final bool isLoggerInfoLoaded;
  final String owner;
  final String loggerName;
  final String location;
  final List<bool> channelLoaded;
  final List<bool> channelInUse;
  final List<String> channelNames;
  final List<String> sensorTypes;
}
