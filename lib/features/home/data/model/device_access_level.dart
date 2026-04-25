enum DeviceAccessLevel {
  viewOnly,
  alarmView,
  all;

  static DeviceAccessLevel fromApiValue(String raw) {
    final value = raw.trim().toLowerCase();
    switch (value) {
      case 'all':
        return DeviceAccessLevel.all;
      case 'alarmview':
        return DeviceAccessLevel.alarmView;
      case 'viewonly':
      default:
        return DeviceAccessLevel.viewOnly;
    }
  }
}
