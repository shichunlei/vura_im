import 'package:azlistview_plus/azlistview_plus.dart';
import 'package:get/get.dart';
import 'package:im/base/base_list_logic.dart';
import 'package:im/entities/user_entity.dart';
import 'package:im/repository/contacts_repository.dart';

class SelectContactsLogic extends BaseListLogic<UserEntity> {
  var selectUsers = RxList<UserEntity>([]);

  late List<int?> selectUserIds;

  SelectContactsLogic() {
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
    SuspensionUtil.sortListBySuspensionTag(list);
    SuspensionUtil.setShowSuspensionStatus(list);
  }
}
