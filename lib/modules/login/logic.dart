import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:im/base/base_logic.dart';
import 'package:im/entities/user_entity.dart';
import 'package:im/modules/root/logic.dart';
import 'package:im/repository/user_repository.dart';
import 'package:im/route/route_path.dart';
import 'package:im/utils/log_utils.dart';

class LoginLogic extends BaseLogic {
  TextEditingController accountController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  LoginLogic() {
    accountController.addListener(update);
    passwordController.addListener(update);
  }

  Future login() async {
    showLoading();
    UserEntity? result =
        await UserRepository.login(userName: accountController.text, password: passwordController.text);
    hiddenLoading();

    if (result != null) {
      try {
        Get.find<RootLogic>().setUserInfo(result);
      } catch (e) {
        Log.e(e.toString());
      }
      Get.offAllNamed(RoutePath.HOME_PAGE);
    }
  }

  void initValues(String account, String password) {
    accountController.text = account;
    passwordController.text = password;
  }
}
