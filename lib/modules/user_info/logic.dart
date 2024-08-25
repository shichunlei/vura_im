import 'package:get/get.dart';
import 'package:im/base/base_object_logic.dart';
import 'package:im/entities/base_bean.dart';
import 'package:im/entities/user_entity.dart';
import 'package:im/global/enum.dart';
import 'package:im/global/keys.dart';
import 'package:im/mixin/friend_mixin.dart';
import 'package:im/modules/home/contacts/logic.dart';
import 'package:im/repository/contacts_repository.dart';
import 'package:im/repository/user_repository.dart';
import 'package:im/utils/log_utils.dart';
import 'package:im/utils/toast_util.dart';

class UserInfoLogic extends BaseObjectLogic<UserEntity?> with FriendMixin {
  String? userId;

  UserInfoLogic() {
    userId = Get.arguments[Keys.ID];
  }

  @override
  void onInit() {
    initData();
    super.onInit();
  }

  @override
  Future<UserEntity?> loadData() async {
    return await UserRepository.getUserInfoById(userId);
  }

  Future removeFromBlacklist() async {
    showLoading();
    BaseBean result = await ContactsRepository.removeFriendFromBlack(bean.value?.id);
    hiddenLoading();
    if (result.code == 200) {
      showToast(text: "已移除黑名单");
      bean.value?.friendship = YorNType.N;
      bean.refresh();
      try {
        Get.find<ContactsLogic>().refreshData();
      } catch (e) {
        Log.e(e.toString());
      }
    }
  }
}
