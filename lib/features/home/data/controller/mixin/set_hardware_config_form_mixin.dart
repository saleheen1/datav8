import 'package:flutter/material.dart';

mixin SetHardwareConfigFormMixin {
  int get totalChannels;
  void update([List<Object>? ids, bool condition = true]);

  final ownerController = TextEditingController();
  final loggerNameController = TextEditingController();
  final locationController = TextEditingController();

  late List<bool> channelInUse;
  late List<bool> isSavingChannel;
  late List<bool> isChannelConfigLoading;
  late List<bool> isChannelConfigLoaded;
  late List<TextEditingController> channelNameControllers;

  bool isLoadingConfig = false;
  bool isLoggerInfoLoading = false;
  bool isLoggerInfoLoaded = false;
  bool isSavingLoggerInfo = false;

  void initFormState() {
    channelInUse = List<bool>.filled(totalChannels, true);
    isSavingChannel = List<bool>.filled(totalChannels, false);
    isChannelConfigLoading = List<bool>.filled(totalChannels, false);
    isChannelConfigLoaded = List<bool>.filled(totalChannels, false);
    channelNameControllers = List.generate(
      totalChannels,
      (_) => TextEditingController(),
    );
  }

  void toggleChannelInUse(int index, bool value) {
    channelInUse[index] = value;
    update();
  }

  void disposeFormControllers() {
    ownerController.dispose();
    loggerNameController.dispose();
    locationController.dispose();
    for (final c in channelNameControllers) {
      c.dispose();
    }
  }
}
