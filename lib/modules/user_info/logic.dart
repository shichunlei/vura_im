import 'package:get/get.dart';
import 'package:im/base/base_object_logic.dart';
import 'package:im/entities/user_entity.dart';
import 'package:im/global/keys.dart';
import 'package:im/mixin/friend_mixin.dart';
import 'package:im/repository/user_repository.dart';

class UserInfoLogic extends BaseObjectLogic<UserEntity?> with FriendMixin {
  String? userId;

  UserInfoLogic() {
    userId = Get.arguments[Keys.ID];
  }

  @override
  Future<UserEntity?> loadData() async {
    return UserRepository.getUserInfoById(userId);
  }
}
