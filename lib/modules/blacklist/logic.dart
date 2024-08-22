import 'package:im/base/base_list_logic.dart';
import 'package:im/entities/base_bean.dart';
import 'package:im/entities/user_entity.dart';
import 'package:im/global/enum.dart';
import 'package:im/repository/contacts_repository.dart';

class BlacklistLogic extends BaseListLogic<UserEntity> {
  @override
  void onInit() {
    initData();
    super.onInit();
  }

  @override
  Future<List<UserEntity>> loadData() async {
    return await ContactsRepository.getBlackList();
  }

  Future remove(int index) async {
    showLoading();
    BaseBean result = await ContactsRepository.removeFriendFromBlack(list[index].id);
    hiddenLoading();
    if (result.code == 200) {
      list.removeAt(index);
      list.refresh();
      if (list.isEmpty) pageState.value = ViewState.empty;
    }
  }
}
