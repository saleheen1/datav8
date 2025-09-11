import 'package:datav8/core/helper/common_helper.dart';
import 'package:datav8/core/themes/custom_theme.dart';
import 'package:datav8/core/utils/text_utils.dart';
import 'package:datav8/core/utils/ui_const.dart';
import 'package:datav8/core/widgets/auth_bottom_text.dart';
import 'package:datav8/core/widgets/button_primary.dart';
import 'package:datav8/core/widgets/custom_input.dart';
import 'package:datav8/core/widgets/default_margin_widget.dart';
import 'package:datav8/core/widgets/logo_widget.dart';
import 'package:datav8/features/auth/presentation/sign_up_page.dart';
import 'package:datav8/features/home/presentation/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = CustomTheme.of(context);
    return GestureDetector(
      onTap: () {
        hideKeyboard(context);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: DefaultMarginWidget(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                LogoWidget(height: 150),
                Text('Login', style: TextUtils.title1Bold(context: context)),
                gapH(5),
                Text(
                  'Enter your email and password to continue',
                  style: TextUtils.b1Regular(
                    context: context,
                    color: theme.greyDark,
                  ),
                ),

                gapH(40),
                CustomInput(labelText: "Email", hintText: 'Enter email'),
                gapH(25),
                CustomInput(
                  labelText: "Password",
                  hintText: 'Enter password',
                  isPasswordField: true,
                ),

                gapH(25),

                ButtonPrimary(text: 'Sign in', onPressed: () {
                  Get.to(Home());
                }),

                gapH(25),

                AuthBottomText(
                  mainText: 'Don’t have an account?  ',
                  actionText: 'Register',
                  onTap: () {
                    Get.to(() => SignUpPage());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
