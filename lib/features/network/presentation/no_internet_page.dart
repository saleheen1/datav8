import 'package:datav8/core/utils/text_utils.dart';
import 'package:datav8/core/widgets/appbar_common.dart';
import 'package:datav8/core/widgets/button_primary.dart';
import 'package:datav8/features/auth/presentation/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoInternetPage extends StatelessWidget {
  const NoInternetPage({super.key});

  void _restartApp() {
    Get.offAll(() => const SplashPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbarCommon('No internet', context, hasBackButton: false),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wifi_off_rounded, size: 72),
              const SizedBox(height: 16),
              Text(
                'Internet is turned off.',
                style: TextUtils.title1Bold(context: context),
              ),
              const SizedBox(height: 8),
              Text(
                'Please turn on your internet connection and restart the app.',
                style: TextUtils.b1Regular(
                  context: context,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
              ButtonPrimary(text: 'Restart App', onPressed: _restartApp),
            ],
          ),
        ),
      ),
    );
  }
}
