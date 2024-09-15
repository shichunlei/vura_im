import 'package:get/get.dart';
import 'package:vura/base/base_logic.dart';
import 'package:vura/entities/session_entity.dart';
import 'package:vura/entities/user_entity.dart';
import 'package:vura/global/enum.dart';
import 'package:vura/modules/root/logic.dart';
import 'package:vura/repository/session_repository.dart';
import 'package:vura/repository/user_repository.dart';
import 'package:vura/utils/session_db_util.dart';

mixin SessionDetailMixin on BaseLogic {
  Rx<SessionEntity?> session = Rx<SessionEntity?>(null);

  UserEntity? user;

  void getSessionDetail(String? id, SessionType type) async {
    if (type == SessionType.private) {
      user = await UserRepository.getUserInfoById(id);
      if (user != null) {
        await SessionRealm(realm: Get.find<RootLogic>().realm).updateSessionInfo(SessionEntity(
            id: user?.id,
            type: SessionType.private,
            name: user?.nickName,
            headImage: user?.headImage,
            headImageThumb: user?.headImageThumb));

        session.value = await SessionRealm(realm: Get.find<RootLogic>().realm).querySessionById(id, type);
      }
    }

    if (type == SessionType.group) {
      session.value = await SessionRepository.getSessionInfo(id);
      if (session.value != null) {
        SessionRealm(realm: Get.find<RootLogic>().realm).updateSessionInfo(session.value!);
      }
    }
  }
}
