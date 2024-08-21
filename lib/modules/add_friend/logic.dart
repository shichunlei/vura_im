import 'package:im/base/base_list_logic.dart';
import 'package:im/entities/base_bean.dart';
import 'package:im/entities/user_entity.dart';
import 'package:im/repository/contacts_repository.dart';
import 'package:im/repository/user_repository.dart';
import 'package:im/utils/toast_util.dart';

class AddFriendLogic extends BaseListLogic<UserEntity> {
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

  Future addFriend(int index) async {
    BaseBean result = await ContactsRepository.addFriend(list[index].id);
    if (result.code == 200) {
      list.removeAt(index);
      showToast(text: "添加好友成功");
    }
  }
}
