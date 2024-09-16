import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vura/application.dart';
import 'package:vura/base/base_logic.dart';
import 'package:vura/entities/user_entity.dart';
import 'package:vura/global/config.dart';
import 'package:vura/modules/contacts/home/logic.dart';
import 'package:vura/modules/im/session/logic.dart';
import 'package:vura/modules/root/logic.dart';
import 'package:vura/modules/setting/account/logic.dart';
import 'package:vura/realm/account.dart';
import 'package:vura/repository/user_repository.dart';
import 'package:vura/route/route_path.dart';
import 'package:vura/utils/account_db_util.dart';
import 'package:vura/utils/device_utils.dart';
import 'package:vura/utils/log_utils.dart';
import 'package:vura/utils/toast_util.dart';

class CheckSecurityIssuesLogic extends BaseLogic {
  String? deviceId;
  String? deviceName;

  String? password;
  String? userName;

  bool switchAccount = false;

  TextEditingController securityIssuesController = TextEditingController();

  CheckSecurityIssuesLogic() {
    password = Get.arguments["password"];
    userName = Get.arguments["userName"];
    switchAccount = Get.arguments?["switchAccount"] ?? false;

    securityIssuesController.addListener(update);

    getDeviceInfo();
  }

  void getDeviceInfo() async {
    deviceId = await DeviceUtils.getDeviceId();
    deviceName = await DeviceUtils.getDeviceName();
  }

  Future check(BuildContext context) async {
    DeviceUtils.hideKeyboard(context);
    if (securityIssuesController.text.isEmpty) {
      showToast(text: "请输入登录账号");
      return;
    }

    showLoading();
    UserEntity? result = await UserRepository.checkSecurityIssues(
        userName: userName,
        password: password,
        deviceId: deviceId,
        deviceName: deviceName,
        answer: securityIssuesController.text);
    hiddenLoading();

    if (result != null) {
      try {
        await AccountRealm(realm: Get.find<RootLogic>().realm).upsert(Account(userName,
            password: password,
            userNo: result.no,
            nickName: result.nickName,
            headImageThumb: result.headImageThumb,
            headImage: result.headImage));
        Get.find<RootLogic>().setUserInfo(result);
      } catch (e) {
        Log.e(e.toString());
      }
      if (result.id != null) AppConfig.setUserId(result.id!);
      if (switchAccount) {
        try {
          if (Get.isRegistered<AccountLogic>()) Get.find<AccountLogic>().refreshData();
          if (Get.isRegistered<SessionLogic>()) Get.find<SessionLogic>().refreshData();
          if (Get.isRegistered<ContactsLogic>()) Get.find<ContactsLogic>().refreshList();
        } catch (e) {
          Log.e(e.toString());
        }
        webSocketManager.switchAccount();
        Get.back();
      } else {
        Get.offAllNamed(RoutePath.HOME_PAGE);
      }
    }
  }

  @override
  void onClose() {
    securityIssuesController.dispose();
    super.onClose();
  }
}
