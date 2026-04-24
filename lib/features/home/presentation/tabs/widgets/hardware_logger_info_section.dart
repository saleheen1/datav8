import 'package:datav8/core/utils/text_utils.dart';
import 'package:datav8/core/utils/ui_const.dart';
import 'package:datav8/core/widgets/button_primary.dart';
import 'package:datav8/core/widgets/custom_input.dart';
import 'package:flutter/material.dart';

class HardwareLoggerInfoSection extends StatelessWidget {
  const HardwareLoggerInfoSection({
    super.key,
    required this.ownerController,
    required this.loggerNameController,
    required this.locationController,
    required this.onSavePressed,
    this.isSaving = false,
  });

  final TextEditingController ownerController;
  final TextEditingController loggerNameController;
  final TextEditingController locationController;
  final VoidCallback onSavePressed;
  final bool isSaving;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 34),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'IMEI: 868926036253869',
            style: TextUtils.title2(context: context, color: Colors.black),
          ),
          gapH(20),
          CustomInput(
            controller: ownerController,
            labelText: "What is the name of the logger's owner?",
            borderColor: Colors.black26,
            focusedBorderColor: Colors.black,
            bgColor: Colors.white,
            paddingVertical: 12,
          ),
          gapH(12),
          CustomInput(
            controller: loggerNameController,
            labelText: 'Give this logger a name',
            borderColor: Colors.black26,
            focusedBorderColor: Colors.black,
            bgColor: Colors.white,
            paddingVertical: 12,
          ),
          gapH(12),
          CustomInput(
            controller: locationController,
            labelText: "Name the logger's location",
            borderColor: Colors.black26,
            focusedBorderColor: Colors.black,
            bgColor: Colors.white,
            paddingVertical: 12,
          ),
          gapH(24),
          ButtonPrimary(
            text: 'Save logger info',
            onPressed: onSavePressed,
            width: 180,
            borderRadius: 5,
            boxshadow: false,
            isLoading: isSaving,
          ),
        ],
      ),
    );
  }
}
