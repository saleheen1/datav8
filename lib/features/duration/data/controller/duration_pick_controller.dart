import 'package:get/get.dart';

enum DurationPick { hours24, days7, days30 }

class DurationPickController extends GetxController {
  final options = [
    DurationPick.hours24,
    DurationPick.days7,
    DurationPick.days30,
  ];
  final titles = ['24 hours', '7 days', '30 days'];
  DurationPick selected = DurationPick.hours24;
  setSelected(DurationPick value) {
    selected = value;
    update();
  }

  void pick(DurationPick value) => selected = value;

  String get chartDurationLabel {
    switch (selected) {
      case DurationPick.hours24:
        return 'Last 24 hours';
      case DurationPick.days7:
        return 'Last 7 days';
      case DurationPick.days30:
        return 'Last 30 days';
    }
  }
}
