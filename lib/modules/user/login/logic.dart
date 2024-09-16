import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:vura/base/base_logic.dart';
import 'package:vura/entities/base_bean.dart';
import 'package:vura/entities/login_entity.dart';
import 'package:vura/entities/user_entity.dart';
import 'package:vura/global/config.dart';
import 'package:vura/global/keys.dart';
import 'package:vura/modules/root/logic.dart';
import 'package:vura/realm/account.dart';
import 'package:vura/repository/user_repository.dart';
import 'package:vura/route/route_path.dart';
import 'package:vura/utils/account_db_util.dart';
import 'package:vura/utils/device_utils.dart';
import 'package:vura/utils/dialog_util.dart';
import 'package:vura/utils/log_utils.dart';
import 'package:vura/utils/sp_util.dart';
import 'package:vura/utils/toast_util.dart';
import 'package:vura/widgets/widgets.dart';

class LoginLogic extends BaseLogic {
  TextEditingController accountController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isIllegalLogin = false;

  String? deviceId;
  String? deviceName;

  LoginLogic() {
    isIllegalLogin = Get.arguments?["isIllegalLogin"] ?? false;
    accountController.addListener(update);
    passwordController.addListener(update);

    getDeviceInfo();
  }

  @override
  void onReady() {
    super.onReady();
    if (isIllegalLogin) {
      show(builder: (_) {
        return const CustomTipDialog(title: "温馨提示", content: "您的账号已在其他设备登录，此次登陆如非本人操作，请立即修改密码，以保护账户财产安全。");
      });
    }
  }

  void getDeviceInfo() async {
    deviceId = await DeviceUtils.getDeviceId();
    deviceName = await DeviceUtils.getDeviceName();
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
    BaseBean result = await UserRepository.login(
        userName: accountController.text,
        password: passwordController.text,
        deviceId: deviceId,
        deviceName: deviceName);
    if (result.code == 200) {
      LoginEntity? login = LoginEntity.fromJson(result.data);
      SpUtil.setString(Keys.ACCESS_TOKEN, "${login.accessToken}");
      SpUtil.setString(Keys.REFRESH_TOKEN, "${login.refreshToken}");
      UserEntity? user = await UserRepository.getUserInfo();
      hiddenLoading();
      if (user != null) {
        try {
          await AccountRealm(realm: Get.find<RootLogic>().realm).upsert(Account(accountController.text,
              password: passwordController.text,
              userNo: user.no,
              nickName: user.nickName,
              headImageThumb: user.headImageThumb,
              headImage: user.headImage));
          Get.find<RootLogic>().setUserInfo(user);
        } catch (e) {
          Log.e(e.toString());
        }
        if (user.id != null) AppConfig.setUserId(user.id!);
        Get.offAllNamed(RoutePath.HOME_PAGE);
      }
    } else if (result.code == 999) {
      show(builder: (BuildContext context) {
        return CustomAlertDialog(
            title: "提示",
            content: "本次登陆需要通过密保问题安全校验，校验通过后方可登录",
            confirmText: "去校验",
            cancelText: "再想想",
            onConfirm: () {
              Get.toNamed(RoutePath.CHECK_SECURITY_ISSUES_PAGE,
                  arguments: {"password": passwordController.text, "userName": accountController.text});
            });
      });
    } else {
      showToast(text: "${result.message}");
      hiddenLoading();
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
