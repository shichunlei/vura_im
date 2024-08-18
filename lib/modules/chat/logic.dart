import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:im/base/base_list_logic.dart';
import 'package:im/entities/message_entity.dart';
import 'package:im/global/enum.dart';
import 'package:im/global/keys.dart';
import 'package:im/modules/home/logic.dart';
import 'package:im/repository/session_repository.dart';
import 'package:im/utils/log_utils.dart';

class ChatLogic extends BaseListLogic<MessageEntity> {
  int? id;
  late String type;

  TextEditingController controller = TextEditingController();

  ChatLogic() {
    id = Get.arguments[Keys.ID];
    type = Get.arguments[Keys.TYPE];

    controller.addListener(update);

    webSocketManager.setOnMessageCallback((int cmd, Map<String, dynamic> data) {
      Log.d("接收到消息: $cmd, 数据: $data");
      if (cmd == WebSocketCode.PRIVATE_MESSAGE.code) {
        list.insert(0, MessageEntity.fromJson(data));
      }
      if (cmd == WebSocketCode.PRIVATE_MESSAGE.code) {
        list.insert(0, MessageEntity.fromJson(data));
      }
      list.refresh();
    });
  }

  @override
  void onInit() {
    initData();
    super.onInit();
  }

  @override
  Future<List<MessageEntity>> loadData() async {
    return SessionRepository.getMessages(id, type);
  }

  Future sendMessage() async {
    MessageEntity? message =
        await SessionRepository.sendMessage(id, type, content: controller.text, type: MessageType.TEXT.code);
    if (message != null) {
      controller.clear();
      list.insert(0, message);
      list.refresh();
    }
  }
}
