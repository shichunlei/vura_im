import 'package:get/get.dart';
import 'package:vura/base/base_object_logic.dart';
import 'package:vura/entities/base_bean.dart';
import 'package:vura/entities/user_entity.dart';
import 'package:vura/global/enum.dart';
import 'package:vura/global/keys.dart';
import 'package:vura/mixin/friend_mixin.dart';
import 'package:vura/modules/contacts/home/logic.dart';
import 'package:vura/repository/contacts_repository.dart';
import 'package:vura/repository/user_repository.dart';
import 'package:vura/utils/toast_util.dart';

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
      if (Get.isRegistered<ContactsLogic>()) Get.find<ContactsLogic>().refreshList();
    }
  }
}
