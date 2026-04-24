import 'package:datav8/core/storage/auth_storage.dart';

mixin SetAlarmsDeviceMixin {
  AuthStorage get authStorage;
  void update([List<Object>? ids, bool condition = true]);

  List<({String title, String imeiRaw})> devices = [];
  String? selectedDeviceTitle;

  void initDevices() {
    final user = authStorage.readUser();
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
      if (d.title == selectedDeviceTitle) {
        return d.imeiRaw;
      }
    }
    return null;
  }
}
