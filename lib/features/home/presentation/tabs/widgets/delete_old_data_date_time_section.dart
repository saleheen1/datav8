import 'package:datav8/core/utils/text_utils.dart';
import 'package:datav8/core/themes/custom_theme.dart';
import 'package:datav8/features/home/data/controller/delete_old_data_controller.dart';
import 'package:flutter/material.dart';

class DeleteOldDataDateTimeSection extends StatelessWidget {
  const DeleteOldDataDateTimeSection({super.key, required this.controller});

  final DeleteOldDataController controller;

  @override
  Widget build(BuildContext context) {
    final dt = controller.selectedDateTime;
    final dateLabel = MaterialLocalizations.of(context).formatMediumDate(dt);
    final timeLabel = MaterialLocalizations.of(
      context,
    ).formatTimeOfDay(TimeOfDay.fromDateTime(dt), alwaysUse24HourFormat: false);

    return Row(
      children: [
        Expanded(
          child: _PickerTile(
            label: 'Date',
            value: dateLabel,
            onTap: () => controller.pickDate(context),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _PickerTile(
            label: 'Time',
            value: timeLabel,
            onTap: () => controller.pickTime(context),
          ),
        ),
      ],
    );
  }
}

class _PickerTile extends StatelessWidget {
  const _PickerTile({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextUtils.captionSemiBold(context: context)),
            const SizedBox(height: 6),
            Text(value, style: TextUtils.b1Regular(context: context)),
          ],
        ),
      ),
    );
  }
}
