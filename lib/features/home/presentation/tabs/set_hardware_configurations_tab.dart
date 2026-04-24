import 'package:datav8/core/utils/text_utils.dart';
import 'package:datav8/core/utils/ui_const.dart';
import 'package:datav8/core/widgets/button_primary.dart';
import 'package:datav8/core/widgets/custom_checkbox.dart';
import 'package:datav8/core/widgets/custom_dropdown.dart';
import 'package:datav8/core/widgets/custom_input.dart';
import 'package:datav8/core/widgets/show_image.dart';
import 'package:datav8/features/home/presentation/tabs/widgets/hardware_logger_info_section.dart';
import 'package:flutter/material.dart';

class SetHardwareConfigurationsTab extends StatefulWidget {
  const SetHardwareConfigurationsTab({super.key});

  @override
  State<SetHardwareConfigurationsTab> createState() =>
      _SetHardwareConfigurationsTabState();
}

class _SetHardwareConfigurationsTabState
    extends State<SetHardwareConfigurationsTab> {
  static const int _channelCount = 5;

  static const List<String> _slotDropdownLabels = [
    'Select Measurement Module in leftmost slot',
    'Select Measurement Module in second from left slot',
    'Select Measurement Module in middle slot',
    'Select Measurement Module in second from right slot',
    'Select Measurement Module in rightmost slot',
  ];

  static const List<String> _moduleOptions = [
    'Temperature Module',
    'Current Module',
    'Voltage Module',
    'Humidity Module',
  ];

  final _ownerController = TextEditingController();
  final _loggerNameController = TextEditingController();
  final _locationController = TextEditingController();
  late final List<bool> _channelInUse;
  late final List<TextEditingController> _channelNameControllers;
  late final List<String> _selectedModules;

  @override
  void initState() {
    super.initState();
    _channelInUse = List<bool>.filled(_channelCount, true);
    _channelNameControllers = List.generate(
      _channelCount,
      (_) => TextEditingController(),
    );
    _selectedModules = List<String>.filled(_channelCount, _moduleOptions.first);
  }

  @override
  void dispose() {
    _ownerController.dispose();
    _loggerNameController.dispose();
    _locationController.dispose();
    for (final c in _channelNameControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          //===============================
          //Logger info
          //===============================
          HardwareLoggerInfoSection(
            ownerController: _ownerController,
            loggerNameController: _loggerNameController,
            locationController: _locationController,
          ),

          //===============================
          //Channel sections
          //===============================
          for (int i = 0; i < _channelCount; i++) ...[
            Text(
              'Channel ${i + 1}',
              style: TextUtils.title1Bold(
                context: context,
                color: Colors.black,
              ),
            ),
            gapH(10),
            CustomCheckbox(
              title: 'Channel ${i + 1} in use',
              value: _channelInUse[i],
              onChanged: (v) {
                setState(() => _channelInUse[i] = v ?? false);
              },
            ),
            if (_channelInUse[i]) ...[
              gapH(12),
              SizedBox(
                width: 260,
                child: CustomInput(
                  controller: _channelNameControllers[i],
                  labelText: 'Give this channel a name',
                  hintText: 'Enter channel name',
                ),
              ),
              gapH(25),
              CustomDropDown(
                label: _slotDropdownLabels[i],
                items: _moduleOptions,
                value: _selectedModules[i],
                onChange: (v) {
                  if (v == null) return;
                  setState(() => _selectedModules[i] = v);
                },
                borderColor: Colors.black26,
              ),
              gapH(20),
              Row(
                children: [
                  Expanded(
                    child: ShowImage(
                      imgLocation:
                          'https://images.unsplash.com/photo-1776943340398-67524b7bcf7f?q=80&w=1740&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                      isAssetImg: false,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ShowImage(
                      imgLocation:
                          'https://images.unsplash.com/photo-1776943340398-67524b7bcf7f?q=80&w=1740&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                      isAssetImg: false,
                    ),
                  ),
                ],
              ),
              gapH(30),
              ButtonPrimary(
                text: 'Save channel ${i + 1}',
                onPressed: () {},
                width: 160,
                borderRadius: 5,
                boxshadow: false,
              ),
            ],
            const SizedBox(height: 26),
            const Divider(color: Colors.black12, thickness: 1),
            const SizedBox(height: 26),
          ],
        ],
      ),
    );
  }
}
