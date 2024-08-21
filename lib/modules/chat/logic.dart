import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:im/application.dart';
import 'package:im/base/base_list_logic.dart';
import 'package:im/entities/message_entity.dart';
import 'package:im/entities/session_entity.dart';
import 'package:im/global/enum.dart';
import 'package:im/global/keys.dart';
import 'package:im/mixin/session_detail_mixin.dart';
import 'package:im/modules/home/session/logic.dart';
import 'package:im/modules/root/logic.dart';
import 'package:im/realm/channel.dart';
import 'package:im/repository/session_repository.dart';
import 'package:im/utils/log_utils.dart';

class ChatLogic extends BaseListLogic<MessageEntity> with SessionDetailMixin {
  int? id;
  late SessionType type;

  TextEditingController controller = TextEditingController();

  ChatLogic() {
    id = Get.arguments[Keys.ID];
    type = Get.arguments[Keys.TYPE];

    controller.addListener(update);

    webSocketManager.listen("ChatLogic-$id-$type", (int cmd, Map<String, dynamic> data) {
      Log.d("ChatLogic == 》接收到消息: $cmd, 数据: $data");
      if (cmd == WebSocketCode.PRIVATE_MESSAGE.code &&
          id == data["sendId"] &&
          (data[Keys.TYPE] <= MessageType.VIDEO.code || data[Keys.TYPE] == MessageType.TIP_TEXT.code)) {
        list.insert(0, MessageEntity.fromJson(data));
      }
      if (cmd == WebSocketCode.GROUP_MESSAGE.code &&
          id == data["groupId"] &&
          (data[Keys.TYPE] <= MessageType.VIDEO.code || data[Keys.TYPE] == MessageType.TIP_TEXT.code)) {
        list.insert(0, MessageEntity.fromJson(data));
      }
      list.refresh();
    });
  }

  @override
  void onInit() {
    getSessionDetail(id, type);
    initData();
    super.onInit();
  }

  @override
  Future<List<MessageEntity>> loadData() async {
    return SessionRepository.getMessages(id, type);
  }

  /// 发送消息
  Future sendMessage() async {
    MessageEntity? message = await SessionRepository.sendMessage(id, type,
        content: controller.text,
        type: MessageType.TEXT,
        receiveHeadImage: session.value?.headImage,
        receiveNickName: session.value?.name);
    if (message != null) {
      controller.clear();
      list.insert(0, message);
      list.refresh();

      SessionRealm(realm: Get.find<RootLogic>().realm)
          .updateLastMessage(
              SessionEntity(
                  id: id,
                  name: session.value?.name,
                  type: type,
                  headImage: session.value?.headImage,
                  lastMessage: message,
                  lastMessageTime: message.sendTime),
              message)
          .then((value) {
        try {
          Get.find<SessionLogic>().refreshList();
        } catch (e) {
          Log.e(e.toString());
        }
      });
    }
  }

  @override
  void onClose() {
    webSocketManager.removeCallbacks("ChatLogic-$id-$type");
    super.onClose();
  }
}
