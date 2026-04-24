import 'package:datav8/core/storage/auth_storage.dart';
import 'package:datav8/core/utils/snackbars.dart';
import 'package:datav8/features/home/data/repo/set_alarms_repo.dart';
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

  Future<void> loadSelectedDeviceAlarmConfig() async {
    if (isFetchingAlarmConfig) return;

    final token = authStorage.readUser()?.token?.trim() ?? '';
    final imei = selectedImeiRaw?.trim() ?? '';
    if (token.isEmpty || imei.isEmpty) return;

    isFetchingAlarmConfig = true;
    update();

    final params = [
      'criticalalarm',
      'monitor_active',
      'thresh_upper',
      'thresh_lower',
      'alarm_delay',
    ];

    for (var i = 0; i < totalChannels; i++) {
      final channel = i + 1;
      for (final param in params) {
        final response = await setAlarmsRepo.getChannelParam(
          imei: imei,
          token: token,
          channel: channel,
          param: param,
        );
        if (!response.isSuccess || response.data == null) {
          isFetchingAlarmConfig = false;
          update();
          showErrorSnackbar(
            'Load failed',
            'Channel $channel - $param: ${response.message}',
            functionName: 'loadSelectedDeviceAlarmConfig',
          );
          return;
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
    }

    isFetchingAlarmConfig = false;
    update();
  }
}
