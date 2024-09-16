import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vura/base/base_logic.dart';
import 'package:vura/entities/base_bean.dart';
import 'package:vura/mixin/auth_code_mixin.dart';
import 'package:vura/modules/setting/account/logic.dart';
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

  late bool isAddAccount;

  String? deviceId;
  String? deviceName;

  RegisterLogic() {
    isAddAccount = Get.arguments?["isAddAccount"] ?? false;

    accountController.addListener(update);
    nicknameController.addListener(update);
    rePasswordController.addListener(update);
    passwordController.addListener(update);
    codeController.addListener(update);
    securityIssuesController.addListener(update);

    getDeviceInfo();
  }

  @override
  void onInit() {
    getAuthCode();
    super.onInit();
  }

  void getDeviceInfo() async {
    deviceId = await DeviceUtils.getDeviceId();
    deviceName = await DeviceUtils.getDeviceName();
  }

  var obscureText = true.obs;
  var reObscureText = true.obs;

  Future register(BuildContext context) async {
    DeviceUtils.hideKeyboard(context);
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
        uuid: base64Img.value?.uuid,
        deviceName: deviceName,
        deviceId: deviceId);
    hiddenLoading();

    if (result.code == 200) {
      showToast(text: "注册成功");
      if (isAddAccount) {
        try {
          Get.find<AccountLogic>().addAccount(accountController.text, nicknameController.text, passwordController.text);
        } catch (e) {
          Log.e(e.toString());
        }
        Get.back();
      } else {
        try {
          Get.find<LoginLogic>().initValues(accountController.text, passwordController.text);
        } catch (e) {
          Log.e(e.toString());
        }

        Get.until((route) => route.settings.name == RoutePath.LOGIN_PAGE);
      }
    } else {
      // 刷新验证码
      getAuthCode();
    }
  }
}
