import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:vura/application.dart';
import 'package:vura/base/base_logic.dart';
import 'package:vura/entities/base_bean.dart';
import 'package:vura/entities/login_entity.dart';
import 'package:vura/entities/user_entity.dart';
import 'package:vura/global/config.dart';
import 'package:vura/global/keys.dart';
import 'package:vura/modules/contacts/home/logic.dart';
import 'package:vura/modules/im/session/logic.dart';
import 'package:vura/modules/root/logic.dart';
import 'package:vura/repository/user_repository.dart';
import 'package:vura/route/route_path.dart';
import 'package:vura/utils/device_utils.dart';
import 'package:vura/utils/dialog_util.dart';
import 'package:vura/utils/sp_util.dart';
import 'package:vura/utils/toast_util.dart';
import 'package:vura/widgets/widgets.dart';

class AddAccountLogic extends BaseLogic {
  TextEditingController accountController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? deviceId;
  String? deviceName;

  AddAccountLogic() {
    accountController.addListener(update);
    passwordController.addListener(update);

    getDeviceInfo();
  }

  Future login(BuildContext context) async {
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
        if (Get.isRegistered<RootLogic>()) Get.find<RootLogic>().setUserInfo(user);
        if (user.id != null) AppConfig.setUserId(user.id!);
        if (Get.isRegistered<SessionLogic>()) Get.find<SessionLogic>().refreshData();
        if (Get.isRegistered<ContactsLogic>()) Get.find<ContactsLogic>().refreshList();
        webSocketManager.switchAccount();
      }
    } else if (result.code == 999) {
      show(builder: (BuildContext context) {
        return CustomAlertDialog(
            title: "提示",
            content: "本次登陆需要通过密保问题安全校验，校验通过后方可登录",
            confirmText: "去校验",
            cancelText: "再想想",
            onConfirm: () {
              Get.offNamed(RoutePath.CHECK_SECURITY_ISSUES_PAGE, arguments: {
                "password": passwordController.text,
                "userName": accountController.text,
                "switchAccount": true
              });
            });
      });
    } else {
      showToast(text: "${result.message}");
      hiddenLoading();
    }

    // showLoading();
    // UserEntity? result = await UserRepository.login(
    //     userName: accountController.text,
    //     password: passwordController.text,
    //     deviceId: deviceId,
    //     deviceName: deviceName);
    // hiddenLoading();

    // if (result != null) {
    //   if (context.mounted) DeviceUtils.hideKeyboard(context);
    //   try {
    //     await AccountRealm(realm: Get.find<RootLogic>().realm).upsert(Account(accountController.text,
    //         password: passwordController.text,
    //         userNo: result.no,
    //         nickName: result.nickName,
    //         headImageThumb: result.headImageThumb,
    //         headImage: result.headImage));
    //     Get.find<RootLogic>().setUserInfo(result);
    //   } catch (e) {
    //     Log.e(e.toString());
    //   }
    //   if (result.id != null) AppConfig.setUserId(result.id!);
    //   Get.offAllNamed(RoutePath.HOME_PAGE);
    // }
  }

  var obscureText = true.obs;

  @override
  void onClose() {
    accountController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void getDeviceInfo() async {
    deviceId = await DeviceUtils.getDeviceId();
    deviceName = await DeviceUtils.getDeviceName();
  }
}
