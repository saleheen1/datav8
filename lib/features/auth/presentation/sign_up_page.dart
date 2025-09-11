import 'package:datav8/core/helper/common_helper.dart';
import 'package:datav8/core/themes/custom_theme.dart';
import 'package:datav8/core/utils/text_utils.dart';
import 'package:datav8/core/utils/ui_const.dart';
import 'package:datav8/core/widgets/appbar_common.dart';
import 'package:datav8/core/widgets/auth_bottom_text.dart';
import 'package:datav8/core/widgets/button_primary.dart';
import 'package:datav8/core/widgets/custom_input.dart';
import 'package:datav8/core/widgets/default_margin_widget.dart';
import 'package:datav8/core/widgets/logo_widget.dart';
import 'package:datav8/features/auth/presentation/login_page.dart';
import 'package:datav8/features/home/presentation/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = CustomTheme.of(context);
    return GestureDetector(
      onTap: () {
        hideKeyboard(context);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: appbarCommon(
          '',
          context,
          leadingWidth: 75,
          showShadow: false,
          backButtonWidget: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 42,
                width: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: theme.border),
                ),
                child: Icon(Icons.arrow_back, size: 20, color: Colors.black),
              ),
            ],
          ),
        ),
        body: DefaultMarginWidget(
          child: Column(
            children: [
              LogoWidget(height: 150),

              Text('Sign Up', style: TextUtils.title1Bold(context: context)),
              gapH(5),
              Text(
                'Enter your details to continue',
                style: TextUtils.b1Regular(
                  context: context,
                  color: theme.greyDark,
                ),
              ),

              gapH(40),
              CustomInput(labelText: "Full Name", hintText: 'Enter full name'),
              gapH(25),
              CustomInput(labelText: "Email", hintText: 'Enter email'),
              gapH(25),
              CustomInput(
                labelText: "Password",
                hintText: 'Enter password',
                isPasswordField: true,
              ),
              gapH(25),

              ButtonPrimary(
                text: 'Sign up',
                onPressed: () {
                  Get.to(Home());
                },
              ),
              gapH(25),

              AuthBottomText(
                mainText: "Already have an account?  ",
                actionText: "Login",
                onTap: () {
                  Get.to(() => LoginPage());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
