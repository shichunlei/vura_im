import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:im/base/base_logic.dart';
import 'package:im/entities/base_bean.dart';
import 'package:im/modules/login/logic.dart';
import 'package:im/repository/user_repository.dart';
import 'package:im/route/route_path.dart';
import 'package:im/utils/log_utils.dart';
import 'package:im/utils/toast_util.dart';

class RegisterLogic extends BaseLogic {
  TextEditingController accountController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nicknameController = TextEditingController();

  RegisterLogic() {
    accountController.addListener(update);
    passwordController.addListener(update);
  }

  Future register() async {
    showLoading();
    BaseBean result = await UserRepository.register(
        userName: accountController.text, password: passwordController.text, nickName: nicknameController.text);
    hiddenLoading();

    if (result.code == 200) {
      showToast(text: "注册成功");

      try {
        Get.find<LoginLogic>().initValues(accountController.text, passwordController.text);
      } catch (e) {
        Log.e(e.toString());
      }

      Get.until((route) => route.settings.name == RoutePath.LOGIN_PAGE);
    }
  }
}
