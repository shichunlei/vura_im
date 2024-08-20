import 'package:get/get.dart';
import 'package:im/base/base_list_logic.dart';
import 'package:im/entities/member_entity.dart';
import 'package:im/global/keys.dart';
import 'package:im/repository/session_repository.dart';

class SessionMembersLogic extends BaseListLogic<MemberEntity> {
  int? id;
  late String title;

  SessionMembersLogic() {
    id = Get.arguments[Keys.ID];
    title = Get.arguments[Keys.TITLE];
  }

  @override
  void onInit() {
    initData();
    super.onInit();
  }

  @override
  Future<List<MemberEntity>> loadData() async {
    return await SessionRepository.getSessionMembers(id);
  }
}
