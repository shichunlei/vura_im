import 'package:get/get.dart';
import 'package:im/entities/member_entity.dart';
import 'package:im/entities/session_entity.dart';
import 'package:im/entities/user_entity.dart';
import 'package:im/global/enum.dart';
import 'package:im/modules/root/logic.dart';
import 'package:im/realm/channel.dart';
import 'package:im/repository/session_repository.dart';
import 'package:im/repository/user_repository.dart';
import 'package:im/utils/log_utils.dart';

mixin SessionDetailMixin on GetxController {
  Rx<SessionEntity?> session = Rx<SessionEntity?>(null);

  void getSessionDetail(String? id, SessionType type, {UserEntity? user}) async {
    SessionEntity? session = await SessionRealm(realm: Get.find<RootLogic>().realm).querySessionById(id, type);
    if (session == null && type == SessionType.private) {
      this.session.value = SessionEntity(id: id, type: type, name: "", headImage: "", headImageThumb: "");
    } else {
      this.session.value = session;
    }

    Log.d("@@@@@@@@@@@@@@@@@${session?.name}-----------${session?.headImage}");
    if (type == SessionType.group) {
      getMembers(id);
    }
    if (type == SessionType.private) {
      UserEntity? user = await UserRepository.getUserInfoById(id);
      if (user != null) {
        await SessionRealm(realm: Get.find<RootLogic>().realm).updateSessionInfo(SessionEntity(
            id: user.id,
            type: SessionType.private,
            name: user.nickName,
            headImage: user.headImage,
            headImageThumb: user.headImageThumb));

        this.session.value = await SessionRealm(realm: Get.find<RootLogic>().realm).querySessionById(id, type);
      }
    }
  }

  RxList<MemberEntity> members = RxList<MemberEntity>([]);

  Future getMembers(String? id) async {
    members.value = await SessionRepository.getSessionMembers(id);
  }
}
