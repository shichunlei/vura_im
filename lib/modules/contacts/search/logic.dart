import 'package:get/get.dart';
import 'package:vura/base/base_list_logic.dart';
import 'package:vura/entities/base_bean.dart';
import 'package:vura/entities/user_entity.dart';
import 'package:vura/global/enum.dart';
import 'package:vura/mixin/friend_mixin.dart';
import 'package:vura/modules/contacts/home/logic.dart';
import 'package:vura/repository/contacts_repository.dart';
import 'package:vura/repository/user_repository.dart';
import 'package:vura/utils/toast_util.dart';

class SearchLogic extends BaseListLogic<UserEntity> with FriendMixin {
  bool isFirst = true;

  @override
  void onInit() {
    initData();
    super.onInit();
  }

  @override
  Future<List<UserEntity>> loadData() async {
    if (isFirst) return [];
    return await UserRepository.searchUserByName(keywords.value);
  }

  @override
  void onCompleted(List<UserEntity> data) {
    isFirst = false;
  }

  void search(String keyword) async {
    keywords.value = keyword;
    showLoading();
    await refreshData();
    hiddenLoading();
  }

  Future removeFromBlacklist(int index) async {
    showLoading();
    BaseBean result = await ContactsRepository.removeFriendFromBlack(list[index].id);
    hiddenLoading();
    if (result.code == 200) {
      showToast(text: "已移除黑名单");
      list[index].friendship = YorNType.N;
      list.refresh();
      if (Get.isRegistered<ContactsLogic>()) Get.find<ContactsLogic>().refreshList();
    }
  }
}
