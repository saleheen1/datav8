import 'package:datav8/core/utils/text_utils.dart';
import 'package:datav8/core/utils/ui_const.dart';
import 'package:datav8/core/utils/snackbars.dart';
import 'package:datav8/core/widgets/button_primary.dart';
import 'package:datav8/core/widgets/custom_dropdown.dart';
import 'package:datav8/features/home/data/controller/device_access_controller.dart';
import 'package:datav8/features/home/data/controller/delete_old_data_controller.dart';
import 'package:datav8/features/home/presentation/tabs/widgets/delete_old_data_date_time_section.dart';
import 'package:datav8/features/home/presentation/tabs/widgets/skeleton/dropdown_saving_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeleteOldDataTab extends StatelessWidget {
  const DeleteOldDataTab({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DeleteOldDataController>(
      builder: (c) {
        final imei = c.selectedImeiRaw ?? '';
        return GetBuilder<DeviceAccessController>(
          builder: (ac) {
            ac.ensureAccessLoaded(imei);
            final canDelete = ac.canDeleteData(imei);
            final isAccessLoading = ac.isLoadingForImei(imei);
            return Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: Colors.grey[100],
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.only(bottom: 24),
                    child: c.isDeleting
                        ? const DropdownSavingSkeleton()
                        : CustomDropDown(
                            label: 'Select device',
                            items: c.devices.map((d) => d.title).toList(),
                            value: c.selectedDeviceTitle,
                            onChange: c.setSelectedDevice,
                            borderColor: Colors.black26,
                            bgColor: Colors.white,
                          ),
                  ),
                  Text(
                    'Clear Data before Date:',
                    style: TextUtils.b1SemiBold(context: context),
                  ),
                  gapH(18),
                  DeleteOldDataDateTimeSection(controller: c),
                  gapH(45),
                  ButtonPrimary(
                    text: 'Clear Data',
                    boxshadow: false,
                    onPressed: () async {
                      if (isAccessLoading) return;
                      if (!canDelete) {
                        showAlertSnackbar(
                          'Access denied',
                          "You don't have access to delete data for this device",
                        );
                        return;
                      }
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (dialogContext) {
                          return AlertDialog(
                            title: const Text('Warning'),
                            content: const Text(
                              'This will permanently delete old data before the selected date/time. Do you want to continue?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(dialogContext).pop(false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(dialogContext).pop(true),
                                child: const Text('Delete'),
                              ),
                            ],
                          );
                        },
                      );
                      if (confirmed == true) {
                        await c.deleteDataBeforeSelectedTime();
                      }
                    },
                    borderRadius: 5,
                    bgColor: canDelete ? null : Colors.grey,
                    isLoading: c.isDeleting || isAccessLoading,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
