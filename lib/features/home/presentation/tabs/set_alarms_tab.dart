import 'package:datav8/core/utils/ui_const.dart';
import 'package:datav8/core/utils/snackbars.dart';
import 'package:datav8/core/widgets/button_primary.dart';
import 'package:datav8/core/widgets/custom_dropdown.dart';
import 'package:datav8/features/home/data/controller/device_access_controller.dart';
import 'package:datav8/features/home/data/controller/set_alarms_controller.dart';
import 'package:datav8/features/home/presentation/tabs/widgets/alarm_channel_section.dart';
import 'package:datav8/features/home/presentation/tabs/widgets/skeleton/alarm_channel_section_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SetAlarmsTab extends StatelessWidget {
  const SetAlarmsTab({super.key});

  static const List<String> _channelTitles = [
    'Channel 1: RoomTemp (\u00B0C)',
    'Channel 2: Server Rack Temp (\u00B0C)',
    'Channel 3: Inverter Rack Temp (\u00B0C)',
    'Channel 4: Inverter Current Out (A-AC)',
    'Channel 5: Battery Voltage (60Vnonisol)',
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SetAlarmsController>(
      autoRemove: true,
      assignId: true,
      builder: (c) {
        final imei = c.selectedImeiRaw ?? '';
        return GetBuilder<DeviceAccessController>(
          builder: (ac) {
            ac.ensureAccessLoaded(imei);
            final canSaveAlarm = ac.canSetAlarm(imei);
            final isAccessLoading = ac.isLoadingForImei(imei);
            return Container(
              color: Colors.white,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
              //===============================
              //Select device
              //===============================
              Container(
                color: Colors.grey[100],
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.only(bottom: 34),
                child: Column(
                  children: [
                    CustomDropDown(
                      label: 'Select device',
                      items: c.devices.map((d) => d.title).toList(),
                      value: c.selectedDeviceTitle,
                      onChange: c.setSelectedDevice,
                      borderColor: Colors.black26,
                      bgColor: Colors.white,
                    ),
                  ],
                ),
              ),

              //===============================
              //Channel sections
              //===============================
              if (c.isChannelConfigLoaded.length !=
                  SetAlarmsController.channelCount)
                for (int i = 0; i < SetAlarmsController.channelCount; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: AlarmChannelSectionSkeleton(
                      title: _channelTitles[i],
                    ),
                  )
              else
                for (int i = 0; i < SetAlarmsController.channelCount; i++) ...[
                  AnimatedSize(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      child:
                          (c.isChannelConfigLoading[i] &&
                                  !c.isChannelConfigLoaded[i]) ||
                              !c.isChannelConfigLoaded[i]
                          ? Padding(
                              key: ValueKey('channel-skeleton-$i'),
                              padding: const EdgeInsets.symmetric(vertical: 30),
                              child: AlarmChannelSectionSkeleton(
                                title: _channelTitles[i],
                              ),
                            )
                          : AlarmChannelSection(
                              key: ValueKey('channel-loaded-$i'),
                              controller: c,
                              index: i,
                              title: _channelTitles[i],
                            ),
                    ),
                  ),

                  //===============================
                  //Save channel button
                  //===============================
                  if (c.isChannelConfigLoaded[i])
                    Column(
                      key: ValueKey('save-btn-$i'),
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        gapH(30),
                        ButtonPrimary(
                          text: 'Save channel ${i + 1}',
                          onPressed: () {
                            if (isAccessLoading) return;
                            if (!canSaveAlarm) {
                              showAlertSnackbar(
                                'Access denied',
                                "You don't have access to set this data",
                              );
                              return;
                            }
                            c.saveChannel(i);
                          },
                          width: 160,
                          borderRadius: 5,
                          boxshadow: false,
                          bgColor: canSaveAlarm ? null : Colors.grey,
                          isLoading: c.isSavingChannel[i] || isAccessLoading,
                        ),
                      ],
                    ),

                  //===============================
                  //Divider
                  //===============================
                  const SizedBox(height: 26),
                  const Divider(color: Colors.black12, thickness: 1),
                  const SizedBox(height: 26),
                ],
                ],
              ),
            );
          },
        );
      },
    );
  }
}
