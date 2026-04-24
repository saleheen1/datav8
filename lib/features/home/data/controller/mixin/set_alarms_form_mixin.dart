import 'package:flutter/material.dart';

mixin SetAlarmsFormMixin {
  int get totalChannels;
  void update([List<Object>? ids, bool condition = true]);

  late final List<bool> isAlarmActive;
  late final List<bool> sendHourlyAlarm;
  late final List<bool> isSavingChannel;
  late final List<TextEditingController> upperLimitControllers;
  late final List<TextEditingController> lowerLimitControllers;
  late final List<TextEditingController> holdoffControllers;

  void initChannelFormState() {
    isAlarmActive = List<bool>.filled(totalChannels, true);
    sendHourlyAlarm = List<bool>.filled(totalChannels, true);
    isSavingChannel = List<bool>.filled(totalChannels, false);
    upperLimitControllers = List.generate(
      totalChannels,
      (_) => TextEditingController(text: '13'),
    );
    lowerLimitControllers = List.generate(
      totalChannels,
      (_) => TextEditingController(text: '12'),
    );
    holdoffControllers = List.generate(
      totalChannels,
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

  void setChannelSaving(int index, bool value) {
    isSavingChannel[index] = value;
    update();
  }

  void disposeChannelControllers() {
    for (final c in upperLimitControllers) {
      c.dispose();
    }
    for (final c in lowerLimitControllers) {
      c.dispose();
    }
    for (final c in holdoffControllers) {
      c.dispose();
    }
  }
}
