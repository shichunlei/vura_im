import 'package:azlistview_plus/azlistview_plus.dart';
import 'package:get/get.dart';
import 'package:im/base/base_list_logic.dart';
import 'package:im/entities/user_entity.dart';
import 'package:im/global/enum.dart';
import 'package:im/mixin/friend_mixin.dart';
import 'package:im/modules/root/logic.dart';
import 'package:im/realm/friend.dart';
import 'package:im/repository/contacts_repository.dart';

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
