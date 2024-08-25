import 'package:get/get.dart';
import 'package:im/base/base_list_logic.dart';
import 'package:im/entities/base_bean.dart';
import 'package:im/entities/user_entity.dart';
import 'package:im/global/enum.dart';
import 'package:im/mixin/friend_mixin.dart';
import 'package:im/mixin/qr_scan_mixin.dart';
import 'package:im/modules/home/contacts/logic.dart';
import 'package:im/repository/contacts_repository.dart';
import 'package:im/repository/user_repository.dart';
import 'package:im/utils/log_utils.dart';
import 'package:im/utils/toast_util.dart';

class AddFriendLogic extends BaseListLogic<UserEntity> with QrScanMixin, FriendMixin {
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
      try {
        Get.find<ContactsLogic>().refreshData();
      } catch (e) {
        Log.e(e.toString());
      }
    }
  }
}
