import 'package:get/get.dart';
import 'package:im/base/base_logic.dart';
import 'package:im/entities/base_bean.dart';
import 'package:im/entities/member_entity.dart';
import 'package:im/entities/session_entity.dart';
import 'package:im/entities/user_entity.dart';
import 'package:im/global/enum.dart';
import 'package:im/global/keys.dart';
import 'package:im/modules/home/session/logic.dart';
import 'package:im/modules/root/logic.dart';
import 'package:im/realm/channel.dart';
import 'package:im/repository/contacts_repository.dart';
import 'package:im/route/route_path.dart';
import 'package:im/utils/log_utils.dart';
import 'package:im/utils/toast_util.dart';

mixin FriendMixin on BaseLogic {
  void goChatPage(UserEntity user) async {
    SessionEntity? session =
        await SessionRealm(realm: Get.find<RootLogic>().realm).querySessionById(user.id, SessionType.private);
    if (session == null) {
      SessionEntity sessionEntity = SessionEntity(
          id: user.id,
          name: user.nickName,
          headImage: user.headImage,
          headImageThumb: user.headImageThumb,
          type: SessionType.private,
          lastMessageTime: DateTime.now().millisecondsSinceEpoch);
      await SessionRealm(realm: Get.find<RootLogic>().realm).upsert(sessionEntityToRealm(sessionEntity)).then((value) {
        try {
          Get.find<SessionLogic>().refreshList();
        } catch (e) {
          Log.e(e.toString());
        }
      });
      Get.toNamed(RoutePath.CHAT_PAGE, arguments: {Keys.ID: user.id, Keys.TYPE: SessionType.private});
    } else {
      session.name = user.nickName;
      session.headImage = user.headImage;
      session.headImageThumb = user.headImageThumb;
      session.type = SessionType.private;
      await SessionRealm(realm: Get.find<RootLogic>().realm).updateSessionInfo(session).then((value) {
        try {
          Get.find<SessionLogic>().refreshList();
        } catch (e) {
          Log.e(e.toString());
        }
      });
      Get.toNamed(RoutePath.CHAT_PAGE, arguments: {Keys.ID: user.id, Keys.TYPE: SessionType.private});
    }
  }

  void goChatPageByMember(MemberEntity user) async {
    SessionEntity? session =
        await SessionRealm(realm: Get.find<RootLogic>().realm).querySessionById(user.userId, SessionType.private);
    if (session == null) {
      SessionEntity sessionEntity = SessionEntity(
          id: user.userId,
          name: user.remarkNickName, // todo
          headImage: user.headImage,
          type: SessionType.private,
          lastMessageTime: DateTime.now().millisecondsSinceEpoch);
      await SessionRealm(realm: Get.find<RootLogic>().realm).upsert(sessionEntityToRealm(sessionEntity)).then((value) {
        try {
          Get.find<SessionLogic>().refreshList();
        } catch (e) {
          Log.e(e.toString());
        }
      });
      Get.toNamed(RoutePath.CHAT_PAGE, arguments: {Keys.ID: user.userId, Keys.TYPE: SessionType.private});
    } else {
      session.name = user.remarkNickName; // todo   并且没有头像缩略图
      session.headImage = user.headImage;
      session.type = SessionType.private;
      await SessionRealm(realm: Get.find<RootLogic>().realm).updateSessionInfo(session).then((value) {
        try {
          Get.find<SessionLogic>().refreshList();
        } catch (e) {
          Log.e(e.toString());
        }
      });
      Get.toNamed(RoutePath.CHAT_PAGE, arguments: {Keys.ID: user.userId, Keys.TYPE: SessionType.private});
    }
  }

  Future applyFriend(String? userId) async {
    BaseBean result = await ContactsRepository.apply(userId);
    if (result.code == 200) {
      showToast(text: "申请已发送");
    }
  }
}
