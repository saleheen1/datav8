import 'package:datav8/core/bindings/all_bindings.dart';
import 'package:datav8/core/themes/custom_theme.dart';
import 'package:datav8/core/themes/light_theme.dart';
import 'package:datav8/features/auth/presentation/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initBindings();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomTheme(
      customThemeData: lightTheme,
      child: GetMaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        home: const SplashPage(),
      ),
    );
  }
}
