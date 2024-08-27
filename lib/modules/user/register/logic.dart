import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vura/base/base_logic.dart';
import 'package:vura/entities/base_bean.dart';
import 'package:vura/mixin/auth_code_mixin.dart';
import 'package:vura/modules/user/login/logic.dart';
import 'package:vura/repository/user_repository.dart';
import 'package:vura/route/route_path.dart';
import 'package:vura/utils/device_utils.dart';
import 'package:vura/utils/log_utils.dart';
import 'package:vura/utils/toast_util.dart';

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
