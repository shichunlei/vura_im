import 'package:get/get.dart';
import 'package:im/base/base_object_logic.dart';
import 'package:im/entities/base_bean.dart';
import 'package:im/entities/member_entity.dart';
import 'package:im/global/keys.dart';
import 'package:im/repository/contacts_repository.dart';
import 'package:im/utils/toast_util.dart';

class SessionMemberLogic extends BaseObjectLogic<MemberEntity> {
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

  Future applyFriend() async {
    BaseBean result = await ContactsRepository.apply(userId);
    if (result.code == 200) {
      // list.removeAt(index);
      showToast(text: "添加好友成功");
    }
  }
}
