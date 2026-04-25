import 'package:datav8/core/storage/auth_storage.dart';
import 'package:datav8/core/utils/snackbars.dart';
import 'package:datav8/features/home/data/repo/delete_old_data_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeleteOldDataController extends GetxController {
  final AuthStorage _authStorage = Get.find<AuthStorage>();
  final DeleteOldDataRepo _repo = Get.find<DeleteOldDataRepo>();

  List<({String title, String imeiRaw})> devices = [];
  String? selectedDeviceTitle;
  DateTime selectedDateTime = DateTime.now().subtract(const Duration(hours: 1));
  bool isDeleting = false;
  bool _isInitialized = false;

  void initializeForHome() {
    if (_isInitialized) return;
    _isInitialized = true;
    _initDevices();
    update();
  }

  void _initDevices() {
    final user = _authStorage.readUser();
    final imeis = user?.imeiList ?? const <String>[];
    final names = user?.loggerList ?? const <String>[];
    final n = imeis.length > names.length ? imeis.length : names.length;

    final rows = <({String title, String imeiRaw})>[];
    for (var i = 0; i < n; i++) {
      final imei = i < imeis.length ? imeis[i].trim() : '';
      final name = i < names.length ? names[i].trim() : '';
      if (imei.isEmpty && name.isEmpty) continue;
      final title = name.isNotEmpty ? name : 'Device ${i + 1}';
      rows.add((title: title, imeiRaw: imei));
    }
    devices = rows;
    selectedDeviceTitle = devices.isNotEmpty ? devices.first.title : null;
  }

  void setSelectedDevice(String? value) {
    selectedDeviceTitle = value;
    update();
  }

  String? get selectedImeiRaw {
    if (selectedDeviceTitle == null) return null;
    for (final d in devices) {
      if (d.title == selectedDeviceTitle) return d.imeiRaw;
    }
    return null;
  }

  int get selectedEpochSeconds => selectedDateTime.millisecondsSinceEpoch ~/ 1000;

  Future<void> deleteDataBeforeSelectedTime() async {
    if (isDeleting) return;
    final token = _authStorage.readUser()?.token?.trim() ?? '';
    final imei = selectedImeiRaw?.trim() ?? '';
    if (token.isEmpty || imei.isEmpty) {
      showErrorSnackbar(
        'Delete failed',
        'Missing selected device IMEI or token',
        functionName: 'deleteDataBeforeSelectedTime',
      );
      return;
    }

    isDeleting = true;
    update();
    final response = await _repo.deleteBeforeEpoch(
      imei: imei,
      token: token,
      epochSeconds: selectedEpochSeconds,
    );
    isDeleting = false;
    update();

    if (!response.isSuccess) {
      showErrorSnackbar(
        'Delete failed',
        response.message,
        functionName: 'deleteDataBeforeSelectedTime',
      );
      return;
    }

    showSuccessSnackbar('Success', 'Old data cleared successfully');
  }

  Future<void> pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked == null) return;
    selectedDateTime = DateTime(
      picked.year,
      picked.month,
      picked.day,
      selectedDateTime.hour,
      selectedDateTime.minute,
    );
    update();
  }

  Future<void> pickTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDateTime),
    );
    if (picked == null) return;
    selectedDateTime = DateTime(
      selectedDateTime.year,
      selectedDateTime.month,
      selectedDateTime.day,
      picked.hour,
      picked.minute,
    );
    update();
  }
}
