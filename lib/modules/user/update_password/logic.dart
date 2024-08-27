import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vura/base/base_logic.dart';
import 'package:vura/entities/base_bean.dart';
import 'package:vura/mixin/auth_code_mixin.dart';
import 'package:vura/repository/user_repository.dart';
import 'package:vura/utils/device_utils.dart';
import 'package:vura/utils/toast_util.dart';

class UpdatePasswordLogic extends BaseLogic with AuthCodeMixin {
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController rePasswordController = TextEditingController();

  UpdatePasswordLogic() {
    oldPasswordController.addListener(update);
    passwordController.addListener(update);
    rePasswordController.addListener(update);
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
  var newObscureText = true.obs;

  Future updatePassword() async {
    DeviceUtils.hideKeyboard(Get.context!);
    if (oldPasswordController.text.isEmpty) {
      showToast(text: "请输入原始密码");
      return;
    }

    if (passwordController.text.isEmpty) {
      showToast(text: "请输入新密码");
      return;
    }

    if (rePasswordController.text != passwordController.text) {
      showToast(text: "两次密码不一致");
      return;
    }

    showLoading();
    BaseBean result = await UserRepository.updatePassword(
        oldPassword: oldPasswordController.text,
        newPassword: passwordController.text,
        answer: securityIssuesController.text,
        code: codeController.text,
        uuid: base64Img.value?.uuid);
    hiddenLoading();

    if (result.code == 200) {
      showToast(text: "修改成功");
    }
  }
}
