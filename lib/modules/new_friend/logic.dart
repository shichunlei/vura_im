import 'package:im/base/base_list_logic.dart';
import 'package:im/entities/user_entity.dart';
import 'package:im/repository/contacts_repository.dart';

class NewFriendLogic extends BaseListLogic<UserEntity> {
  @override
  void onInit() {
    initData();
    super.onInit();
  }

  @override
  Future<List<UserEntity>> loadData() async {
    return await ContactsRepository.getBlackList();
  }

  Future remove(int index)async{
    ContactsRepository.removeFriendFromBlack(list[index].id);
  }
}
