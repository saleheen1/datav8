import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SetAlarmsController extends GetxController {
  static const int channelCount = 5;

  late final List<bool> isAlarmActive;
  late final List<bool> sendHourlyAlarm;
  late final List<TextEditingController> upperLimitControllers;
  late final List<TextEditingController> lowerLimitControllers;
  late final List<TextEditingController> holdoffControllers;

  @override
  void onInit() {
    super.onInit();
    isAlarmActive = List<bool>.filled(channelCount, true);
    sendHourlyAlarm = List<bool>.filled(channelCount, true);
    upperLimitControllers = List.generate(
      channelCount,
      (_) => TextEditingController(text: '13'),
    );
    lowerLimitControllers = List.generate(
      channelCount,
      (_) => TextEditingController(text: '12'),
    );
    holdoffControllers = List.generate(
      channelCount,
      (_) => TextEditingController(text: '2'),
    );
  }

  void toggleAlarmActive(int index, bool value) {
    isAlarmActive[index] = value;
    update();
  }

  void toggleSendHourlyAlarm(int index, bool value) {
    sendHourlyAlarm[index] = value;
    update();
  }

  void saveAlarms() {
    // TODO: connect with API when endpoint is ready.
  }

  @override
  void onClose() {
    for (final c in upperLimitControllers) {
      c.dispose();
    }
    for (final c in lowerLimitControllers) {
      c.dispose();
    }
    for (final c in holdoffControllers) {
      c.dispose();
    }
    super.onClose();
  }
}
