import 'package:datav8/core/utils/text_utils.dart';
import 'package:datav8/core/utils/ui_const.dart';
import 'package:datav8/core/widgets/button_primary.dart';
import 'package:datav8/core/widgets/custom_checkbox.dart';
import 'package:datav8/core/widgets/custom_input.dart';
import 'package:datav8/features/home/data/controller/set_alarms_controller.dart';
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
      builder: (c) {
        return Container(
          color: Colors.white,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              for (int i = 0; i < SetAlarmsController.channelCount; i++) ...[
                _buildChannelSection(context, c, i),

                if (c.isAlarmActive[i])
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      gapH(30),
                      ButtonPrimary(
                        text: 'Save channel ${i + 1}',
                        onPressed: c.saveAlarms,
                        width: 160,
                        borderRadius: 5,
                        boxshadow: false,
                      ),
                    ],
                  ),
                const SizedBox(height: 26),
                const Divider(color: Colors.black12, thickness: 1),
                const SizedBox(height: 26),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildChannelSection(
    BuildContext context,
    SetAlarmsController c,
    int index,
  ) {
    final channelNo = index + 1;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _channelTitles[index],
          style: TextUtils.title1Bold(context: context, color: Colors.black),
        ),
        const SizedBox(height: 10),
        CustomCheckbox(
          title: 'Alarms active on channel $channelNo',
          value: c.isAlarmActive[index],
          onChanged: (v) {
            c.toggleAlarmActive(index, v ?? false);
          },
        ),
        if (c.isAlarmActive[index]) ...[
          const SizedBox(height: 12),
          Container(
            width: 220,
            margin: EdgeInsets.only(bottom: 10),
            child: CustomInput(
              controller: c.upperLimitControllers[index],
              labelText: 'Upper Limit',
              isNumberField: true,
              paddingVertical: 12,
              borderColor: Colors.black26,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            width: 220,
            child: CustomInput(
              controller: c.lowerLimitControllers[index],
              labelText: 'Lower Limit',
              isNumberField: true,
              paddingVertical: 12,
              borderColor: Colors.black26,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            width: 220,
            child: CustomInput(
              controller: c.holdoffControllers[index],
              labelText: 'Alarm Holdoff (minutes)',
              isNumberField: true,
              paddingVertical: 12,
              borderColor: Colors.black26,
            ),
          ),
          const SizedBox(height: 12),
          CustomCheckbox(
            title: 'Channel sends alarm every hour while in alarm condition',
            value: c.sendHourlyAlarm[index],
            onChanged: (v) {
              c.toggleSendHourlyAlarm(index, v ?? false);
            },
          ),
        ],
      ],
    );
  }
}
