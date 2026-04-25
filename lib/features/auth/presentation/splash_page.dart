import 'package:datav8/core/widgets/logo_widget.dart';
import 'package:datav8/features/auth/data/controller/auth_controller.dart';
import 'package:datav8/features/auth/presentation/login_page.dart';
import 'package:datav8/features/home/data/controller/set_alarms_controller.dart';
import 'package:datav8/features/home/data/controller/set_hardware_configurations_controller.dart';
import 'package:datav8/features/home/presentation/home_page.dart';
import 'package:datav8/core/network/connectivity_guard_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _boot();
  }

  Future<void> _boot() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final connectivityGuard = Get.find<ConnectivityGuardService>();
    final isConnected = await connectivityGuard.hasInternetConnection();
    if (!isConnected) {
      await connectivityGuard.takeUserToNoInternetPage();
      return;
    }

    Get.find<SetAlarmsController>().clearAlarmConfigCache();
    Get.find<SetHardwareConfigurationsController>().clearHardwareConfigCache();

    final auth = Get.find<AuthController>();
    await auth.restoreSessionIfAny();
    if (!mounted) return;
    Get.offAll(() => auth.isLoggedIn ? const HomePage() : const LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [LogoWidget()],
        ),
      ),
    );
  }
}
