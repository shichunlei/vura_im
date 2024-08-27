import 'package:get/get.dart';
import 'package:vura/base/base_list_logic.dart';
import 'package:vura/entities/member_entity.dart';
import 'package:vura/global/keys.dart';
import 'package:vura/repository/session_repository.dart';

class SessionMembersLogic extends BaseListLogic<MemberEntity> {
  String? id;
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
