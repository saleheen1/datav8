import 'package:datav8/core/utils/snackbars.dart';
import 'package:get/get.dart';

mixin LoginValidationMixin {
  bool validateCredentials(String email, String password) {
    if (email.isEmpty || password.isEmpty) {
      showAlertSnackbar('Required', 'Please enter email and password');
      return false;
    }

    if (!GetUtils.isEmail(email)) {
      showAlertSnackbar('Invalid email', 'Please enter a valid email address');
      return false;
    }

    return true;
  }
}
