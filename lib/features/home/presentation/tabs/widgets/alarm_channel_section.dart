import 'package:datav8/core/utils/text_utils.dart';
import 'package:datav8/core/widgets/custom_checkbox.dart';
import 'package:datav8/core/widgets/custom_input.dart';
import 'package:datav8/features/home/data/controller/set_alarms_controller.dart';
import 'package:flutter/material.dart';

class AlarmChannelSection extends StatelessWidget {
  const AlarmChannelSection({
    super.key,
    required this.controller,
    required this.index,
    required this.title,
  });

  final SetAlarmsController controller;
  final int index;
  final String title;

  @override
  Widget build(BuildContext context) {
    final channelNo = index + 1;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextUtils.title1Bold(context: context, color: Colors.black),
        ),
        const SizedBox(height: 10),
        CustomCheckbox(
          title: 'Alarms active on channel $channelNo',
          value: controller.isAlarmActive[index],
          onChanged: (v) {
            controller.toggleAlarmActive(index, v ?? false);
          },
        ),
        if (controller.isAlarmActive[index]) ...[
          const SizedBox(height: 12),
          Container(
            width: 220,
            margin: const EdgeInsets.only(bottom: 10),
            child: CustomInput(
              controller: controller.upperLimitControllers[index],
              labelText: 'Upper Limit',
              isNumberField: true,
              paddingVertical: 12,
              borderColor: Colors.black26,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            width: 220,
            child: CustomInput(
              controller: controller.lowerLimitControllers[index],
              labelText: 'Lower Limit',
              isNumberField: true,
              paddingVertical: 12,
              borderColor: Colors.black26,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            width: 220,
            child: CustomInput(
              controller: controller.holdoffControllers[index],
              labelText: 'Alarm Holdoff (minutes)',
              isNumberField: true,
              paddingVertical: 12,
              borderColor: Colors.black26,
            ),
          ),
          const SizedBox(height: 12),
          CustomCheckbox(
            title: 'Channel sends alarm every hour while in alarm condition',
            value: controller.sendHourlyAlarm[index],
            onChanged: (v) {
              controller.toggleSendHourlyAlarm(index, v ?? false);
            },
          ),
        ],
      ],
    );
  }
}
