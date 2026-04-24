import 'package:datav8/core/utils/snackbars.dart';
import 'package:datav8/features/home/data/model/hardware_sensor_option_model.dart';
import 'package:datav8/features/home/data/repo/hardware_sensor_repo.dart';
import 'package:get/get.dart';

class SetHardwareSensorDropdownController extends GetxController {
  final HardwareSensorRepo sensorRepo = Get.find<HardwareSensorRepo>();

  static const int _channelCount = 5;
  bool isLoading = false;
  List<HardwareSensorOptionModel> sensors = [];
  late final List<String?> _selectedSensorIndexByChannel;
  List<String> get dropdownItems => sensors.map((s) => s.label).toList();

  setLoading(bool value) {
    isLoading = value;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    _selectedSensorIndexByChannel = List<String?>.filled(_channelCount, null);
    fetchSensors();
  }

  String? selectedLabelForChannel(int channelIndex) {
    final idx = _selectedSensorIndexByChannel[channelIndex];
    if (idx == null) return null;
    for (final s in sensors) {
      if (s.index == idx) return s.label;
    }
    return null;
  }

  void setSelectedByLabel(int channelIndex, String label) {
    for (final s in sensors) {
      if (s.label == label) {
        _selectedSensorIndexByChannel[channelIndex] = s.index;
        update();
        return;
      }
    }
  }

  void setSelectedBySensorType(
    int channelIndex,
    String sensorType, {
    bool notify = true,
  }) {
    final wanted = sensorType.trim().toLowerCase();
    if (wanted.isEmpty) return;
    for (final s in sensors) {
      if (s.boardName.trim().toLowerCase() == wanted) {
        _selectedSensorIndexByChannel[channelIndex] = s.index;
        if (notify) update();
        return;
      }
    }
  }

  String sensorImageForChannel(int channelIndex) {
    final selected = _selectedForChannel(channelIndex);
    return selected?.sensorImageUrl ?? '';
  }

  String moduleImageForChannel(int channelIndex) {
    final selected = _selectedForChannel(channelIndex);
    return selected?.moduleImageUrl ?? '';
  }

  HardwareSensorOptionModel? _selectedForChannel(int channelIndex) {
    final idx = _selectedSensorIndexByChannel[channelIndex];
    if (idx == null) return null;
    for (final s in sensors) {
      if (s.index == idx) return s;
    }
    return null;
  }

  HardwareSensorOptionModel? selectedForChannel(int channelIndex) {
    return _selectedForChannel(channelIndex);
  }

  //=======================================================
  //Fetch sensors
  //=======================================================
  Future<void> fetchSensors() async {
    setLoading(true);
    try {
      final listResponse = await sensorRepo.fetchSensorList();
      if (!listResponse.isSuccess || listResponse.data == null) {
        throw Exception(listResponse.message);
      }
      final options = List<HardwareSensorOptionModel>.from(listResponse.data!);

      for (int i = 0; i < options.length; i++) {
        final detailResponse = await sensorRepo.fetchSensorDetail(options[i]);
        if (!detailResponse.isSuccess || detailResponse.data == null) {
          continue;
        }
        options[i] = detailResponse.data!;
      }

      sensors = options;
      if (sensors.isNotEmpty) {
        final defaultIndex = sensors.first.index;
        for (var i = 0; i < _channelCount; i++) {
          _selectedSensorIndexByChannel[i] ??= defaultIndex;
        }
      }
    } catch (e) {
      showErrorSnackbar(
        'Sensor load failed',
        e.toString(),
        functionName: 'fetchSensors',
      );
    } finally {
      setLoading(false);
      update();
    }
  }
}
