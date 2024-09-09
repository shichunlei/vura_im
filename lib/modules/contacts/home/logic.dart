import 'package:azlistview_plus/azlistview_plus.dart';
import 'package:get/get.dart';
import 'package:vura/base/base_list_logic.dart';
import 'package:vura/entities/user_entity.dart';
import 'package:vura/global/enum.dart';
import 'package:vura/mixin/friend_mixin.dart';
import 'package:vura/modules/root/logic.dart';
import 'package:vura/repository/contacts_repository.dart';
import 'package:vura/utils/friend_db_util.dart';

class ContactsLogic extends BaseListLogic<UserEntity> with FriendMixin {
  @override
  void onInit() {
    initData();
    super.onInit();
  }

  @override
  Future<List<UserEntity>> loadData() async {
    return await ContactsRepository.getFriendList();
  }

  @override
  void onCompleted(List<UserEntity> data) {
    super.onCompleted(data);
    SuspensionUtil.sortListBySuspensionTag(list);
    SuspensionUtil.setShowSuspensionStatus(list);
    if (data.isNotEmpty) saveToRealm(data);
  }

  void saveToRealm(List<UserEntity> users) async {
    for (var user in users) {
      user.friendship = YorNType.Y;
      await FriendRealm(realm: Get.find<RootLogic>().realm).upsert(friendEntityToRealm(user));
    }
    refreshList();
  }

  void refreshList() async {
    list.value = await FriendRealm(realm: Get.find<RootLogic>().realm).queryAllFriends();
    SuspensionUtil.sortListBySuspensionTag(list);
    SuspensionUtil.setShowSuspensionStatus(list);
    list.refresh();
  }
}
