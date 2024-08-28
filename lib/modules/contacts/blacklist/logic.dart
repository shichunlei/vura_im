import 'package:get/get.dart';
import 'package:vura/base/base_list_logic.dart';
import 'package:vura/entities/base_bean.dart';
import 'package:vura/entities/user_entity.dart';
import 'package:vura/global/enum.dart';
import 'package:vura/modules/contacts/home/logic.dart';
import 'package:vura/modules/root/logic.dart';
import 'package:vura/realm/channel.dart';
import 'package:vura/repository/contacts_repository.dart';
import 'package:vura/utils/log_utils.dart';

class BlacklistLogic extends BaseListLogic<UserEntity> {
  @override
  void onInit() {
    initData();
    super.onInit();
  }

  @override
  Future<List<UserEntity>> loadData() async {
    return await ContactsRepository.getBlackList();
  }

  Future remove(int index) async {
    showLoading();
    BaseBean result = await ContactsRepository.removeFriendFromBlack(list[index].id);
    hiddenLoading();
    if (result.code == 200) {
      SessionRealm(realm: Get.find<RootLogic>().realm).blacklistChannel(list[index].id, YorNType.Y);
      list.removeAt(index);
      list.refresh();
      if (list.isEmpty) pageState.value = ViewState.empty;
      try {
        Get.find<ContactsLogic>().refreshData();
      } catch (e) {
        Log.e(e.toString());
      }
    }
  }
}
