import 'package:datav8/core/utils/text_utils.dart';
import 'package:datav8/core/utils/ui_const.dart';
import 'package:datav8/core/utils/snackbars.dart';
import 'package:datav8/core/widgets/button_primary.dart';
import 'package:datav8/core/widgets/custom_checkbox.dart';
import 'package:datav8/core/widgets/custom_dropdown.dart';
import 'package:datav8/core/widgets/custom_input.dart';
import 'package:datav8/core/widgets/show_image.dart';
import 'package:datav8/features/home/data/controller/device_access_controller.dart';
import 'package:datav8/features/home/data/controller/set_hardware_configurations_controller.dart';
import 'package:datav8/features/home/data/controller/set_hardware_sensor_dropdown_controller.dart';
import 'package:datav8/features/home/presentation/tabs/widgets/hardware_logger_info_section.dart';
import 'package:datav8/features/home/presentation/tabs/widgets/skeleton/dropdown_saving_skeleton.dart';
import 'package:datav8/features/home/presentation/tabs/widgets/skeleton/hardware_channel_section_skeleton.dart';
import 'package:datav8/features/home/presentation/tabs/widgets/skeleton/hardware_logger_info_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SetHardwareConfigurationsTab extends StatelessWidget {
  const SetHardwareConfigurationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SetHardwareConfigurationsController>(
      autoRemove: false,
      builder: (c) {
        return GetBuilder<SetHardwareSensorDropdownController>(
          builder: (s) {
            final imei = c.selectedImeiRaw ?? '';
            return GetBuilder<DeviceAccessController>(
              builder: (ac) {
                ac.ensureAccessLoaded(imei);
                final canSetHardware = ac.canSetHardware(imei);
                final isAccessLoading = ac.isLoadingForImei(imei);
                final isSavingAnyData =
                    c.isSavingLoggerInfo ||
                    c.isSavingChannel.any((isSaving) => isSaving);
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
                            isSavingAnyData
                                ? const DropdownSavingSkeleton()
                                : CustomDropDown(
                                    label: 'Select device',
                                    items: c.devices
                                        .map((d) => d.title)
                                        .toList(),
                                    value: c.selectedDeviceTitle,
                                    onChange: c.setSelectedDevice,
                                    borderColor: Colors.black26,
                                    bgColor: Colors.white,
                                  ),
                          ],
                        ),
                      ),

                      //===============================
                      //Logger info
                      //===============================
                      (c.isLoggerInfoLoading || !c.isLoggerInfoLoaded)
                          ? const HardwareLoggerInfoSkeleton()
                          : HardwareLoggerInfoSection(
                              ownerController: c.ownerController,
                              loggerNameController: c.loggerNameController,
                              locationController: c.locationController,
                              onSavePressed: c.saveLoggerInfo,
                              onNoAccessPressed: () => showAlertSnackbar(
                                'Access denied',
                                "You don't have access to set this data",
                              ),
                              isSaving: c.isSavingLoggerInfo,
                              canSave: canSetHardware,
                              isAccessLoading: isAccessLoading,
                            ),

                      //===============================
                      //Channel sections
                      //===============================
                      for (
                        int i = 0;
                        i < SetHardwareConfigurationsController.channelCount;
                        i++
                      ) ...[
                        Text(
                          'Channel ${i + 1}',
                          style: TextUtils.title1Bold(
                            context: context,
                            color: Colors.black,
                          ),
                        ),
                        gapH(10),
                        if (!c.isChannelConfigLoading[i] &&
                            c.isChannelConfigLoaded[i])
                          CustomCheckbox(
                            title: 'Channel ${i + 1} in use',
                            value: c.channelInUse[i],
                            onChanged: (v) {
                              c.toggleChannelInUse(i, v ?? false);
                            },
                          ),
                        if (c.isChannelConfigLoading[i] ||
                            !c.isChannelConfigLoaded[i])
                          const HardwareChannelSectionSkeleton()
                        else if (c.isChannelConfigLoaded[i] &&
                            c.channelInUse[i]) ...[
                          gapH(12),
                          SizedBox(
                            width: 260,
                            child: CustomInput(
                              controller: c.channelNameControllers[i],
                              labelText: 'Give this channel a name',
                              hintText: 'Enter channel name',
                            ),
                          ),
                          gapH(25),
                          CustomDropDown(
                            label: SetHardwareConfigurationsController
                                .slotDropdownLabels[i],
                            items: s.dropdownItems,
                            value: s.selectedLabelForChannel(i),
                            onChange: (v) {
                              if (v == null) return;
                              s.setSelectedByLabel(i, v);
                            },
                            borderColor: Colors.black26,
                          ),
                          gapH(20),
                          Row(
                            children: [
                              Expanded(
                                child: _buildSensorImage(
                                  s.sensorImageForChannel(i),
                                  'Sensor image',
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildSensorImage(
                                  s.moduleImageForChannel(i),
                                  'Module image',
                                ),
                              ),
                            ],
                          ),
                        ],
                        gapH(30),
                        if (!c.isChannelConfigLoading[i] &&
                            c.isChannelConfigLoaded[i])
                          ButtonPrimary(
                            text: 'Save channel ${i + 1}',
                            onPressed: () {
                              if (isAccessLoading) return;
                              if (!canSetHardware) {
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
                            bgColor: canSetHardware ? null : Colors.grey,
                            isLoading: c.isSavingChannel[i] || isAccessLoading,
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
          },
        );
      },
    );
  }

  Widget _buildSensorImage(String imageUrl, String placeholderText) {
    if (imageUrl.isEmpty) {
      return Container(
        height: 110,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[100],
        ),
        child: Text(
          placeholderText,
          style: const TextStyle(color: Colors.black54),
        ),
      );
    }
    return ShowImage(imgLocation: imageUrl, isAssetImg: false);
  }
}
