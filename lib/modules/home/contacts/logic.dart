import 'package:azlistview_plus/azlistview_plus.dart';
import 'package:get/get.dart';
import 'package:im/base/base_list_logic.dart';
import 'package:im/entities/user_entity.dart';
import 'package:im/modules/root/logic.dart';
import 'package:im/realm/friend.dart';
import 'package:im/repository/contacts_repository.dart';

class ContactsLogic extends BaseListLogic<UserEntity> {
  bool _isLoadFromNet = false;

  @override
  void onInit() {
    initData();
    super.onInit();
  }

  @override
  Future<List<UserEntity>> loadData() async {
    List<UserEntity> users = [];
    users = await FriendRealm(realm: Get.find<RootLogic>().realm).queryAllFriends();
    if (users.isEmpty) {
      _isLoadFromNet = true;
      users = await ContactsRepository.getFriendList();
    }
    return users;
  }

  @override
  void onCompleted(List<UserEntity> data) {
    super.onCompleted(data);
    SuspensionUtil.sortListBySuspensionTag(list);
    SuspensionUtil.setShowSuspensionStatus(list);
    if (data.isNotEmpty && _isLoadFromNet) {
      saveToRealm(list);
    } else {
      asyncFriends();
    }
  }

  void asyncFriends() async {
    List<UserEntity> users = await ContactsRepository.getFriendList();
    if (users.isNotEmpty) saveToRealm(users);
  }

  void saveToRealm(List<UserEntity> users) async {
    for (var user in users) {
      await FriendRealm(realm: Get.find<RootLogic>().realm).upsert(friendEntityToRealm(user));
    }
    list.value = await FriendRealm(realm: Get.find<RootLogic>().realm).queryAllFriends();
    SuspensionUtil.sortListBySuspensionTag(list);
    SuspensionUtil.setShowSuspensionStatus(list);
    list.refresh();
  }
}
