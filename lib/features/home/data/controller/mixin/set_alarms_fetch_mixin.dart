import 'package:datav8/core/storage/auth_storage.dart';
import 'package:datav8/core/utils/snackbars.dart';
import 'package:datav8/features/home/data/repo/set_alarms_repo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

mixin SetAlarmsFetchMixin {
  int get totalChannels;
  SetAlarmsRepo get setAlarmsRepo;
  AuthStorage get authStorage;

  List<bool> get isAlarmActive;
  List<bool> get sendHourlyAlarm;
  List<TextEditingController> get upperLimitControllers;
  List<TextEditingController> get lowerLimitControllers;
  List<TextEditingController> get holdoffControllers;
  String? get selectedImeiRaw;
  void update([List<Object>? ids, bool condition = true]);

  bool isFetchingAlarmConfig = false;
  late List<bool> isChannelConfigLoading;
  late List<bool> isChannelConfigLoaded;
  CancelToken? _activeFetchCancelToken;
  int _activeFetchRunId = 0;
  final Map<String, _SetAlarmDeviceCache> _deviceConfigCache = {};

  void initFetchState() {
    isChannelConfigLoading = List<bool>.filled(totalChannels, false);
    isChannelConfigLoaded = List<bool>.filled(totalChannels, false);
  }

  void clearAlarmConfigCache() {
    _deviceConfigCache.clear();
    isFetchingAlarmConfig = false;
    isChannelConfigLoading = List<bool>.filled(totalChannels, false);
    isChannelConfigLoaded = List<bool>.filled(totalChannels, false);
  }

  void cancelAlarmConfigLoading({bool notify = true}) {
    _activeFetchCancelToken?.cancel('Device changed');
    _activeFetchCancelToken = null;
    _activeFetchRunId++;
    isFetchingAlarmConfig = false;
    for (var i = 0; i < totalChannels; i++) {
      isChannelConfigLoading[i] = false;
    }
    if (notify) {
      update();
    }
  }

  Future<void> loadSelectedDeviceAlarmConfig() async {
    cancelAlarmConfigLoading();

    final token = authStorage.readUser()?.token?.trim() ?? '';
    final imei = selectedImeiRaw?.trim() ?? '';
    if (token.isEmpty || imei.isEmpty) return;
    _applyCachedConfig(imei);
    if (isChannelConfigLoaded.every((loaded) => loaded)) return;

    final runId = _activeFetchRunId;
    final cancelToken = CancelToken();
    _activeFetchCancelToken = cancelToken;

    isFetchingAlarmConfig = true;
    isChannelConfigLoading = List<bool>.filled(totalChannels, false);
    update();

    final params = [
      'criticalalarm',
      'monitor_active',
      'thresh_upper',
      'thresh_lower',
      'alarm_delay',
    ];

    for (var i = 0; i < totalChannels; i++) {
      if (isChannelConfigLoaded[i]) continue;
      final channel = i + 1;
      isChannelConfigLoading[i] = true;
      update();

      var channelLoaded = true;
      for (final param in params) {
        final response = await setAlarmsRepo.getChannelParam(
          imei: imei,
          token: token,
          channel: channel,
          param: param,
          cancelToken: cancelToken,
        );
        if (runId != _activeFetchRunId) return;
        if (!response.isSuccess || response.data == null) {
          final message = response.message.toLowerCase();
          final wasCanceled =
              message.contains('cancel') || message.contains('device changed');
          if (wasCanceled) {
            isChannelConfigLoading[i] = false;
            update();
            return;
          }
          channelLoaded = false;
          showErrorSnackbar(
            'Load failed',
            'Channel $channel - $param: ${response.message}',
            functionName: 'loadSelectedDeviceAlarmConfig',
          );
          break;
        }

        final value = response.data!.trim();
        switch (param) {
          case 'criticalalarm':
            sendHourlyAlarm[i] = value == '1';
            break;
          case 'monitor_active':
            isAlarmActive[i] = value == '1';
            break;
          case 'thresh_upper':
            upperLimitControllers[i].text = value;
            break;
          case 'thresh_lower':
            lowerLimitControllers[i].text = value;
            break;
          case 'alarm_delay':
            holdoffControllers[i].text = value;
            break;
        }
      }

      isChannelConfigLoading[i] = false;
      isChannelConfigLoaded[i] = channelLoaded;
      if (channelLoaded) {
        _saveCurrentToCache(imei);
      }
      update();

      if (!channelLoaded) {
        isFetchingAlarmConfig = false;
        update();
        return;
      }
    }

    if (runId != _activeFetchRunId) return;
    _activeFetchCancelToken = null;
    isFetchingAlarmConfig = false;
    _saveCurrentToCache(imei);
    update();
  }

  void _applyCachedConfig(String imei) {
    final cached = _deviceConfigCache[imei];
    isChannelConfigLoaded = List<bool>.filled(totalChannels, false);
    if (cached == null) return;

    for (var i = 0; i < totalChannels; i++) {
      final isLoaded = cached.channelLoaded[i];
      isChannelConfigLoaded[i] = isLoaded;
      if (!isLoaded) continue;
      isAlarmActive[i] = cached.isAlarmActive[i];
      sendHourlyAlarm[i] = cached.sendHourlyAlarm[i];
      upperLimitControllers[i].text = cached.upperLimits[i];
      lowerLimitControllers[i].text = cached.lowerLimits[i];
      holdoffControllers[i].text = cached.holdoffs[i];
      isChannelConfigLoading[i] = false;
    }

    isFetchingAlarmConfig = false;
    update();
  }

  void saveCurrentConfigToCacheForSelectedDevice() {
    final imei = selectedImeiRaw?.trim() ?? '';
    if (imei.isEmpty) return;
    _saveCurrentToCache(imei);
  }

  void _saveCurrentToCache(String imei) {
    final existing = _deviceConfigCache[imei];
    final channelLoaded = existing != null
        ? List<bool>.from(existing.channelLoaded)
        : List<bool>.filled(totalChannels, false);
    final alarmActive = existing != null
        ? List<bool>.from(existing.isAlarmActive)
        : List<bool>.filled(totalChannels, true);
    final hourlyAlarm = existing != null
        ? List<bool>.from(existing.sendHourlyAlarm)
        : List<bool>.filled(totalChannels, true);
    final upperLimits = existing != null
        ? List<String>.from(existing.upperLimits)
        : List<String>.filled(totalChannels, '13');
    final lowerLimits = existing != null
        ? List<String>.from(existing.lowerLimits)
        : List<String>.filled(totalChannels, '12');
    final holdoffs = existing != null
        ? List<String>.from(existing.holdoffs)
        : List<String>.filled(totalChannels, '2');

    for (var i = 0; i < totalChannels; i++) {
      if (!isChannelConfigLoaded[i]) continue;
      channelLoaded[i] = true;
      alarmActive[i] = isAlarmActive[i];
      hourlyAlarm[i] = sendHourlyAlarm[i];
      upperLimits[i] = upperLimitControllers[i].text.trim();
      lowerLimits[i] = lowerLimitControllers[i].text.trim();
      holdoffs[i] = holdoffControllers[i].text.trim();
    }

    _deviceConfigCache[imei] = _SetAlarmDeviceCache(
      channelLoaded: channelLoaded,
      isAlarmActive: alarmActive,
      sendHourlyAlarm: hourlyAlarm,
      upperLimits: upperLimits,
      lowerLimits: lowerLimits,
      holdoffs: holdoffs,
    );
  }
}

class _SetAlarmDeviceCache {
  _SetAlarmDeviceCache({
    required this.channelLoaded,
    required this.isAlarmActive,
    required this.sendHourlyAlarm,
    required this.upperLimits,
    required this.lowerLimits,
    required this.holdoffs,
  });

  final List<bool> channelLoaded;
  final List<bool> isAlarmActive;
  final List<bool> sendHourlyAlarm;
  final List<String> upperLimits;
  final List<String> lowerLimits;
  final List<String> holdoffs;
}
