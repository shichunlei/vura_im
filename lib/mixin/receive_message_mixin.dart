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
import 'package:vura/utils/friend_db_util.dart';
import 'package:vura/utils/log_utils.dart';
import 'package:vura/utils/message_db_util.dart';
import 'package:vura/utils/session_db_util.dart';
import 'package:vura/utils/string_util.dart';

mixin ReceiveMessageMixin on BaseLogic {
  final RootLogic rootLogic = Get.find<RootLogic>(); // 获取依赖

  var loadingGroupMessages = false.obs;
  var loadingPrivateMessages = false.obs;

  void receiveMessageListener(String pageName) {
    webSocketManager.listen(pageName, (int cmd, Map<String, dynamic> data) async {
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
            data[Keys.TYPE] == MessageType.PRIVATE_RED_PACKET_TIP_TEXT.code ||
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
          message.sessionType = SessionType.private;

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
            data[Keys.TYPE] == MessageType.GROUP_RED_PACKET_TIP_TEXT.code ||
            data[Keys.TYPE] >= MessageType.RED_PACKAGE.code) {
          MessageEntity message = MessageEntity.fromJson(data);
          message.sessionType = SessionType.group;

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
        } else if (data[Keys.TYPE] >= 300 && data[Keys.TYPE] < 400) {
          /// 群踢人 {"cmd":4,"data":{"groupId":"1829665405703159809", "userIds": ["1826517087758188544"], "type":306}}
          if (data[Keys.TYPE] == MessageType.REMOVE_MEMBERS_FROM_GROUP.code) {
            // removeMembers(id, (data["userIds"] as List).map((item) => item.toString()).toList());
          }

          /// 解散群聊 {"cmd":4,"data":{"groupId":"1829665405703159809", "type":308}}
          if (data[Keys.TYPE] == MessageType.DISSOLUTION_GROUP.code) {
            /// 删除本地群聊
            SessionRealm(realm: Get.find<RootLogic>().realm).deleteChannel(data["groupId"], SessionType.group);
          }

          /// 设置管理员 {"cmd":4,"data":{"groupId":"1829665405703159809", "userIds": ["1826517087758188544"], "type":303}}
          if (data[Keys.TYPE] == MessageType.SET_SUP_ADMIN.code) {
            // setSupAdmin((data["userIds"] as List).map((item) => item.toString()).toList());
          }

          /// 取消管理员 {"cmd":4,"data":{"groupId":"1829665405703159809", "userIds": ["1826517087758188544"], "type":304}}
          if (data[Keys.TYPE] == MessageType.REMOVE_SUP_ADMIN.code) {
            // resetSupAdmin((data["userIds"] as List).map((item) => item.toString()).toList());
          }

          /// 群主换让 {"cmd":4,"data":{"groupId":"1829665405703159809", "userId":"1826517087758188544","type":305}}
          if (data[Keys.TYPE] == MessageType.TRANSFER_ADMIN.code) {}

          /// 群加人 {"cmd":4,"data":{"groupId":"1829665405703159809", "userIds": ["1826517087758188544"], "type":307}}
          if (data[Keys.TYPE] == MessageType.ADD_MEMBERS_TO_GROUP.code) {}
        }
      }
    });
  }
}
