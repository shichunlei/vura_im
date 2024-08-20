import 'package:get/get.dart';
import 'package:im/entities/member_entity.dart';
import 'package:im/entities/session_entity.dart';
import 'package:im/entities/user_entity.dart';
import 'package:im/global/enum.dart';
import 'package:im/modules/root/logic.dart';
import 'package:im/realm/channel.dart';
import 'package:im/repository/session_repository.dart';

mixin SessionDetailMixin on GetxController {
  Rx<SessionEntity?> session = Rx<SessionEntity?>(null);

  void getSessionDetail(int? id, SessionType type, {UserEntity? user}) async {
    SessionEntity? session = await SessionRealm(realm: Get.find<RootLogic>().realm).querySessionById(id);
    if (session == null && type == SessionType.private) {
      this.session.value = SessionEntity(id: id, type: type, name: "", headImage: "", headImageThumb: "");
    } else {
      this.session.value = session;
    }

    if (type == SessionType.group) getMembers(id);
  }

  RxList<MemberEntity> members = RxList<MemberEntity>([]);

  Future getMembers(int? id) async {
    members.value = await SessionRepository.getSessionMembers(id);
  }
}
