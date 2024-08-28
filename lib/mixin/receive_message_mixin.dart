import 'package:get/get.dart';
import 'package:vura/application.dart';
import 'package:vura/base/base_logic.dart';
import 'package:vura/entities/message_entity.dart';
import 'package:vura/entities/session_entity.dart';
import 'package:vura/global/config.dart';
import 'package:vura/global/enum.dart';
import 'package:vura/global/keys.dart';
import 'package:vura/modules/im/session/logic.dart';
import 'package:vura/modules/root/logic.dart';
import 'package:vura/realm/channel.dart';
import 'package:vura/realm/friend.dart';
import 'package:vura/realm/message.dart';
import 'package:vura/utils/log_utils.dart';
import 'package:vura/utils/string_util.dart';

mixin ReceiveMessageMixin on BaseLogic {
  final RootLogic rootLogic = Get.find<RootLogic>(); // 获取依赖

  var loadingGroupMessages = false.obs;
  var loadingPrivateMessages = false.obs;

  void receiveMessageListener(String pageName) {
    webSocketManager.listen(pageName, (int cmd, Map<String, dynamic> data) async {
      Log.d("SessionLogic == 》接收到消息: $cmd, 数据: $data");
      if (cmd == WebSocketCode.PRIVATE_MESSAGE.code) {
        if (data[Keys.TYPE] == MessageType.LOADING.code) {
          if (data[Keys.CONTENT] == "true") loadingPrivateMessages.value = true;
          if (data[Keys.CONTENT] == "false") {
            loadingPrivateMessages.value = false;
            try {
              Get.find<SessionLogic>().refreshList();
            } catch (e) {
              Log.e(e.toString());
            }
          }
        } else if (data[Keys.TYPE] < MessageType.RECALL.code ||
            data[Keys.TYPE] == MessageType.TIP_TEXT.code ||
            data[Keys.TYPE] >= MessageType.RED_PACKAGE.code) {
          MessageEntity message = MessageEntity.fromJson(data);
          String? myUserId = AppConfig.userId;
          String? sessionId;
          String? headImage;
          String? name;
          if (message.sendId != myUserId) {
            sessionId = message.sendId;
            headImage = message.sendHeadImage;
            if (StringUtil.isEmpty(message.sendNickName)) {
              name = await FriendRealm(realm: rootLogic.realm).queryFriendNicknameById(sessionId);
            } else {
              name = message.sendNickName;
            }
          }
          if (message.receiveId != myUserId) {
            sessionId = message.receiveId;
            headImage = message.receiveHeadImage;
            if (StringUtil.isEmpty(message.receiveNickName)) {
              name = await FriendRealm(realm: rootLogic.realm).queryFriendNicknameById(sessionId);
            } else {
              name = message.receiveNickName;
            }
          }
          message.sessionId = sessionId;

          /// 存储消息
          await MessageRealm(realm: rootLogic.realm).upsert(messageEntityToRealm(message));

          /// 会话列表最后一条消息显示
          SessionRealm(realm: rootLogic.realm)
              .updateLastMessage(
                  SessionEntity(
                      id: sessionId,
                      name: name,
                      type: SessionType.private,
                      headImage: headImage,
                      lastMessage: message,
                      lastMessageTime: message.sendTime),
                  message)
              .then((value) {
            if (!loadingPrivateMessages.value) {
              try {
                Get.find<SessionLogic>().refreshList();
              } catch (e) {
                Log.e(e.toString());
              }
            }
          });
        }
      }
      if (cmd == WebSocketCode.GROUP_MESSAGE.code) {
        if (data[Keys.TYPE] == MessageType.LOADING.code) {
          if (data[Keys.CONTENT] == "true") loadingGroupMessages.value = true;
          if (data[Keys.CONTENT] == "false") {
            loadingGroupMessages.value = false;
            try {
              Get.find<SessionLogic>().refreshList();
            } catch (e) {
              Log.e(e.toString());
            }
          }
        } else if (data[Keys.TYPE] < MessageType.RECALL.code ||
            data[Keys.TYPE] == MessageType.TIP_TEXT.code ||
            data[Keys.TYPE] >= MessageType.RED_PACKAGE.code) {
          MessageEntity message = MessageEntity.fromJson(data);

          /// 存储消息
          MessageRealm(realm: rootLogic.realm).upsert(messageEntityToRealm(message));

          /// 会话列表最后一条消息显示
          SessionRealm(realm: rootLogic.realm)
              .updateLastMessage(
                  SessionEntity(
                      id: message.sessionId,
                      type: SessionType.group,
                      lastMessage: message,
                      name: message.groupName,
                      lastMessageTime: message.sendTime),
                  message)
              .then((value) {
            if (!loadingGroupMessages.value) {
              try {
                Get.find<SessionLogic>().refreshList();
              } catch (e) {
                Log.e(e.toString());
              }
            }
          });
        }
      }
    });
  }
}
