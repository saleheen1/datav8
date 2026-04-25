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
  static const Color _appBlue = Color(0xff1999FA);

  @override
  Widget build(BuildContext context) {
    return CustomTheme(
      customThemeData: lightTheme,
      child: GetMaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: _appBlue),
          primaryColor: _appBlue,
          dialogTheme: const DialogThemeData(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
          ),
          datePickerTheme: const DatePickerThemeData(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
          ),
          timePickerTheme: const TimePickerThemeData(
            backgroundColor: Colors.white,
            dialBackgroundColor: Colors.white,
          ),
        ),
        home: const SplashPage(),
      ),
    );
  }
}
