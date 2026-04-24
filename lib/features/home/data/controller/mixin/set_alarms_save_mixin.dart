import 'package:datav8/core/storage/auth_storage.dart';
import 'package:datav8/core/utils/snackbars.dart';
import 'package:datav8/features/home/data/repo/set_alarms_repo.dart';
import 'package:flutter/material.dart';

mixin SetAlarmsSaveMixin {
  SetAlarmsRepo get setAlarmsRepo;
  AuthStorage get authStorage;

  List<bool> get isSavingChannel;
  List<bool> get sendHourlyAlarm;
  List<bool> get isAlarmActive;
  List<TextEditingController> get upperLimitControllers;
  List<TextEditingController> get lowerLimitControllers;
  List<TextEditingController> get holdoffControllers;
  String? get selectedImeiRaw;

  void setChannelSaving(int index, bool value);

  Future<void> saveChannel(int index) async {
    if (isSavingChannel[index]) return;

    final user = authStorage.readUser();
    final token = user?.token?.trim() ?? '';
    final imei = selectedImeiRaw?.trim() ?? '';

    if (token.isEmpty || imei.isEmpty) {
      showErrorSnackbar(
        'Save failed',
        'Missing selected device IMEI or token',
        functionName: 'saveChannel',
      );
      return;
    }

    final channel = index + 1;
    final requests = [
      (param: 'criticalalarm', value: sendHourlyAlarm[index] ? '1' : '0'),
      (param: 'monitor_active', value: isAlarmActive[index] ? '1' : '0'),
      (param: 'thresh_upper', value: upperLimitControllers[index].text.trim()),
      (param: 'thresh_lower', value: lowerLimitControllers[index].text.trim()),
      (param: 'alarm_delay', value: holdoffControllers[index].text.trim()),
    ];

    setChannelSaving(index, true);
    for (final req in requests) {
      final response = await setAlarmsRepo.setChannelParam(
        imei: imei,
        token: token,
        channel: channel,
        param: req.param,
        value: req.value,
      );
      if (!response.isSuccess) {
        setChannelSaving(index, false);
        showErrorSnackbar(
          'Save failed',
          'Channel $channel - ${req.param}: ${response.message}',
          functionName: 'saveChannel',
        );
        return;
      }
    }
    setChannelSaving(index, false);
    showSuccessSnackbar('Saved', 'Channel $channel alarm settings saved');
  }
}
