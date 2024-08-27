import 'package:azlistview_plus/azlistview_plus.dart';
import 'package:get/get.dart';
import 'package:vura/base/base_list_logic.dart';
import 'package:vura/entities/user_entity.dart';
import 'package:vura/repository/contacts_repository.dart';

class AccountLogic extends BaseListLogic<UserEntity> {
  var selectIndex = 0.obs;

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
