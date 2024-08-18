import 'package:im/base/base_object_logic.dart';
import 'package:im/entities/user_entity.dart';
import 'package:im/repository/user_repository.dart';

class PersonalLogic extends BaseObjectLogic<UserEntity?> {
  @override
  void onInit() {
    initData();
    super.onInit();
  }

  @override
  Future<UserEntity?> loadData() async {
    return await UserRepository.getUserInfo();
  }
}
