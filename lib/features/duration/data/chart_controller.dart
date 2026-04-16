import 'package:datav8/core/storage/auth_storage.dart';
import 'package:datav8/features/duration/data/controller/duration_pick_controller.dart';
import 'package:datav8/features/duration/data/model/chart_retrieve_model.dart';
import 'package:datav8/features/duration/data/repo/chart_repo.dart';
import 'package:get/get.dart';

class ChartController extends GetxController {
  final ChartRepo _chartRepo = Get.find<ChartRepo>();
  final AuthStorage _authStorage = Get.find<AuthStorage>();

  bool isLoading = false;
  ChartRetrieveModel? lastRetrieveData;

  void setLoading(bool value) {
    isLoading = value;
    update();
  }

  static int _unixNow() => DateTime.now().millisecondsSinceEpoch ~/ 1000;
  static int startEpochFor(DurationPick pick, int endUnix) {
    switch (pick) {
      case DurationPick.hours24:
        return endUnix - 24 * 3600;
      case DurationPick.days7:
        return endUnix - 7 * 24 * 3600;
      case DurationPick.days30:
        return endUnix - 30 * 24 * 3600;
    }
  }

  //=======================================================
  //Retrieve chart data for a device
  //=======================================================

  Future<bool> retrieveForDevice(String imeiRaw, DurationPick pick) async {
    if (isLoading) return false;
    final token = _authStorage.readUser()?.token;
    final end = _unixNow();
    final start = startEpochFor(pick, end);
    setLoading(true);
    final response = await _chartRepo.retrieve(imeiRaw, token!, start, end);
    setLoading(false);

    if (response.isSuccess) {
      lastRetrieveData = response.data;
    }
    update();
    return response.isSuccess;
  }
}
