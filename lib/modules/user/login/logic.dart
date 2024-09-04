import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:vura/base/base_logic.dart';
import 'package:vura/entities/user_entity.dart';
import 'package:vura/global/config.dart';
import 'package:vura/modules/root/logic.dart';
import 'package:vura/realm/account.dart';
import 'package:vura/repository/user_repository.dart';
import 'package:vura/route/route_path.dart';
import 'package:vura/utils/device_utils.dart';
import 'package:vura/utils/log_utils.dart';
import 'package:vura/utils/toast_util.dart';

class LoginLogic extends BaseLogic {
  TextEditingController accountController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  LoginLogic() {
    accountController.addListener(update);
    passwordController.addListener(update);
  }

  Future login(BuildContext context) async {
    DeviceUtils.hideKeyboard(context);
    if (accountController.text.isEmpty) {
      showToast(text: "请输入登录账号");
      return;
    }

    if (passwordController.text.isEmpty) {
      showToast(text: "请输入登录密码");
      return;
    }

    showLoading();
    UserEntity? result =
        await UserRepository.login(userName: accountController.text, password: passwordController.text);
    hiddenLoading();

    if (result != null) {
      try {
        await AccountRealm(realm: Get.find<RootLogic>().realm)
            .upsert(Account(accountController.text, password: passwordController.text));
        Get.find<RootLogic>().setUserInfo(result);
      } catch (e) {
        Log.e(e.toString());
      }
      if (result.id != null) AppConfig.setUserId(result.id!);
      Get.offAllNamed(RoutePath.HOME_PAGE);
    }
  }

  void initValues(String account, String password) {
    accountController.text = account;
    passwordController.text = password;
  }

  var obscureText = true.obs;

  @override
  void onClose() {
    accountController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
