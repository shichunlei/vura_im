import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vura/application.dart';
import 'package:vura/base/base_list_logic.dart';
import 'package:vura/entities/account_entity.dart';
import 'package:vura/entities/base_bean.dart';
import 'package:vura/entities/login_entity.dart';
import 'package:vura/entities/user_entity.dart';
import 'package:vura/global/config.dart';
import 'package:vura/global/keys.dart';
import 'package:vura/modules/contacts/home/logic.dart';
import 'package:vura/modules/im/session/logic.dart';
import 'package:vura/modules/root/logic.dart';
import 'package:vura/realm/account.dart';
import 'package:vura/repository/user_repository.dart';
import 'package:vura/route/route_path.dart';
import 'package:vura/utils/account_db_util.dart';
import 'package:vura/utils/device_utils.dart';
import 'package:vura/utils/dialog_util.dart';
import 'package:vura/utils/sp_util.dart';
import 'package:vura/utils/toast_util.dart';
import 'package:vura/widgets/widgets.dart';

class AccountLogic extends BaseListLogic<AccountEntity> {
  var selectIndex = 0.obs;

  String? deviceId;
  String? deviceName;

  AccountLogic() {
    getDeviceInfo();
  }

  @override
  void onInit() {
    initData();
    super.onInit();
  }

  @override
  Future<List<AccountEntity>> loadData() async {
    return await AccountRealm(realm: Get.find<RootLogic>().realm).queryAllAccounts();
  }

  @override
  void onCompleted(List<AccountEntity> data) {
    if (data.isNotEmpty) {
      selectIndex.value = data.indexWhere((item) => Get.find<RootLogic>().user.value?.userName == item.userName);
    }
  }

  Future switchAccount(int index) async {
    selectIndex.value = index;
    showLoading();
    BaseBean result = await UserRepository.login(
        userName: list[index].userName, password: list[index].password, deviceId: deviceId, deviceName: deviceName);
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
              Get.toNamed(RoutePath.CHECK_SECURITY_ISSUES_PAGE, arguments: {
                "password": list[index].password,
                "userName": list[index].userName,
                "switchAccount": true
              });
            });
      });
    } else {
      showToast(text: "${result.message}");
      hiddenLoading();
    }
  }

  Future addAccount(String userName, String nickName, String password) async {
    AccountRealm(realm: Get.find<RootLogic>().realm)
        .upsert(Account(userName, nickName: nickName, password: password))
        .then((value) {
      refreshData();
    });
  }

  void getDeviceInfo() async {
    deviceId = await DeviceUtils.getDeviceId();
    deviceName = await DeviceUtils.getDeviceName();
  }
}
