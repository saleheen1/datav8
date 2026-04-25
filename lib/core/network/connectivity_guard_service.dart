import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:datav8/features/network/presentation/no_internet_page.dart';
import 'package:get/get.dart';

class ConnectivityGuardService extends GetxService {
  final Connectivity _connectivity = Connectivity();
  bool _isNavigatingToNoInternet = false;

  Future<bool> hasInternetConnection() async {
    final result = await _connectivity.checkConnectivity();
    return result.any((item) => item != ConnectivityResult.none);
  }

  Future<void> takeUserToNoInternetPage() async {
    if (_isNavigatingToNoInternet) return;
    _isNavigatingToNoInternet = true;
    Get.offAll(() => const NoInternetPage());
    await Future<void>.delayed(const Duration(milliseconds: 100));
    _isNavigatingToNoInternet = false;
  }
}
