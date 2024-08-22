import 'package:get/get.dart';
import 'package:im/base/base_object_logic.dart';
import 'package:im/entities/member_entity.dart';
import 'package:im/global/keys.dart';
import 'package:im/mixin/friend_mixin.dart';

class SessionMemberLogic extends BaseObjectLogic<MemberEntity> with FriendMixin {
  String? userId;
  String? groupId;

  SessionMemberLogic() {
    userId = Get.arguments[Keys.ID];
    groupId = Get.arguments["groupId"];
  }

  @override
  Future<MemberEntity> loadData() async {
    return MemberEntity();
  }
}
