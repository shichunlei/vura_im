import 'package:azlistview_plus/azlistview_plus.dart';
import 'package:get/get.dart';
import 'package:vura/base/base_list_logic.dart';
import 'package:vura/entities/user_entity.dart';
import 'package:vura/global/enum.dart';
import 'package:vura/modules/root/logic.dart';
import 'package:vura/repository/contacts_repository.dart';
import 'package:vura/utils/friend_db_util.dart';

class SelectContactsLogic extends BaseListLogic<UserEntity> {
  var selectUsers = RxList<UserEntity>([]);

  late bool isCheckBox;

  late List<String?> selectUserIds;

  SelectContactsLogic() {
    isCheckBox = Get.arguments?["isCheckBox"] ?? true;
    selectUserIds = Get.arguments?["selectUserIds"] ?? [];
  }

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
    if (data.isNotEmpty) {
      SuspensionUtil.sortListBySuspensionTag(list);
      SuspensionUtil.setShowSuspensionStatus(list);
      _allUsers.clear();
      _allUsers.addAll(list);
      saveToRealm(data);
    }
  }

  final List<UserEntity> _allUsers = [];

  void search(String keyword) async {
    if (keywords.value == keyword) return;
    keywords.value = keyword;
    if (keywords.value.isEmpty) {
      list.value = _allUsers;
    } else {
      list.value = _allUsers
          .where((element) => element.nickName.toString().toUpperCase().contains(keywords.value.toUpperCase()))
          .toList();
    }
    SuspensionUtil.sortListBySuspensionTag(list);
    SuspensionUtil.setShowSuspensionStatus(list);
    list.refresh();
  }

  void saveToRealm(List<UserEntity> users) {
    for (var user in users) {
      user.friendship = YorNType.Y;
      FriendRealm(realm: Get.find<RootLogic>().realm).upsert(friendEntityToRealm(user));
    }
  }
}
