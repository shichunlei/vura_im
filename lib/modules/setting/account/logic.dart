import 'package:get/get.dart';
import 'package:vura/application.dart';
import 'package:vura/base/base_list_logic.dart';
import 'package:vura/entities/account_entity.dart';
import 'package:vura/entities/user_entity.dart';
import 'package:vura/global/config.dart';
import 'package:vura/modules/contacts/home/logic.dart';
import 'package:vura/modules/im/session/logic.dart';
import 'package:vura/modules/root/logic.dart';
import 'package:vura/realm/account.dart';
import 'package:vura/repository/user_repository.dart';
import 'package:vura/utils/account_db_util.dart';

class AccountLogic extends BaseListLogic<AccountEntity> {
  var selectIndex = 0.obs;

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
    UserEntity? result = await UserRepository.login(userName: list[index].userName, password: list[index].password);
    hiddenLoading();

    if (result != null) {
      if (Get.isRegistered<RootLogic>()) Get.find<RootLogic>().setUserInfo(result);
      if (result.id != null) AppConfig.setUserId(result.id!);
      if (Get.isRegistered<SessionLogic>()) Get.find<SessionLogic>().refreshData();
      if (Get.isRegistered<ContactsLogic>()) Get.find<ContactsLogic>().refreshList();
      webSocketManager.switchAccount();
      // Get.until((route) => route.settings.name == RoutePath.HOME_PAGE);
    }
  }

  Future addAccount(String userName, String nickName, String password) async {
    AccountRealm(realm: Get.find<RootLogic>().realm)
        .upsert(Account(userName, nickName: nickName, password: password))
        .then((value) {
      refreshData();
    });
  }
}
