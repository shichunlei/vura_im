import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:im/base/base_logic.dart';
import 'package:im/entities/base_bean.dart';
import 'package:im/mixin/auth_code_mixin.dart';
import 'package:im/modules/login/logic.dart';
import 'package:im/repository/user_repository.dart';
import 'package:im/route/route_path.dart';
import 'package:im/utils/device_utils.dart';
import 'package:im/utils/log_utils.dart';
import 'package:im/utils/toast_util.dart';

class RegisterLogic extends BaseLogic with AuthCodeMixin {
  TextEditingController accountController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nicknameController = TextEditingController();
  TextEditingController rePasswordController = TextEditingController();

  RegisterLogic() {
    accountController.addListener(update);
    nicknameController.addListener(update);
    rePasswordController.addListener(update);
    passwordController.addListener(update);
    codeController.addListener(update);
    securityIssuesController.addListener(update);
  }

  @override
  void onInit() {
    getAuthCode();
    super.onInit();
  }

  var obscureText = true.obs;
  var reObscureText = true.obs;

  Future register() async {
    DeviceUtils.hideKeyboard(Get.context!);
    if (accountController.text.isEmpty) {
      showToast(text: "请输入账号");
      return;
    }

    if (passwordController.text.isEmpty) {
      showToast(text: "请输入密码");
      return;
    }

    if (rePasswordController.text != passwordController.text) {
      showToast(text: "两次密码不一致");
      return;
    }

    showLoading();
    BaseBean result = await UserRepository.register(
        userName: accountController.text,
        password: passwordController.text,
        nickName: nicknameController.text,
        answer: securityIssuesController.text,
        code: codeController.text,
        uuid: base64Img.value?.uuid);
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
