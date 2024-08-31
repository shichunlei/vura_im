import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vura/application.dart';
import 'package:vura/base/base_list_logic.dart';
import 'package:vura/entities/file_entity.dart';
import 'package:vura/entities/message_entity.dart';
import 'package:vura/entities/red_package.dart';
import 'package:vura/entities/session_entity.dart';
import 'package:vura/entities/user_entity.dart';
import 'package:vura/global/enum.dart';
import 'package:vura/global/keys.dart';
import 'package:vura/mixin/session_detail_mixin.dart';
import 'package:vura/modules/im/session/logic.dart';
import 'package:vura/modules/root/logic.dart';
import 'package:vura/realm/channel.dart';
import 'package:vura/realm/message.dart';
import 'package:vura/repository/common_repository.dart';
import 'package:vura/repository/session_repository.dart';
import 'package:vura/route/route_path.dart';
import 'package:vura/utils/log_utils.dart';
import 'package:vura/utils/string_util.dart';
import 'package:vura/utils/toast_util.dart';
import 'package:vura/utils/tool_util.dart';

class ChatLogic extends BaseListLogic<MessageEntity> with SessionDetailMixin {
  String? id;
  late SessionType type;

  TextEditingController controller = TextEditingController();

  ChatLogic() {
    id = Get.arguments[Keys.ID];
    type = Get.arguments[Keys.TYPE];

    setPageSize(200);

    controller.addListener(update);

    webSocketManager.listen("ChatLogic-$id-$type", (int cmd, Map<String, dynamic> data) {
      Log.d("ChatLogic == 》接收到消息: $cmd, 数据: $data");
      if (cmd == WebSocketCode.PRIVATE_MESSAGE.code &&
          id == data["sendId"] &&
          (data[Keys.TYPE] < MessageType.RECALL.code ||
              data[Keys.TYPE] == MessageType.TIP_TEXT.code ||
              data[Keys.TYPE] >= MessageType.RED_PACKAGE.code)) {
        list.insert(0, MessageEntity.fromJson(data));
      }
      if (cmd == WebSocketCode.GROUP_MESSAGE.code &&
          id == data[Keys.GROUP_ID] &&
          (data[Keys.TYPE] < MessageType.RECALL.code ||
              data[Keys.TYPE] == MessageType.TIP_TEXT.code ||
              data[Keys.TYPE] >= MessageType.RED_PACKAGE.code)) {
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
    return SessionRepository.getMessages(id, type, page: pageNumber.value, size: pageSize.value);
  }

  /// 发送消息
  Future sendMessage(String content, MessageType messageType) async {
    if (StringUtil.isEmpty(content)) {
      showToast(text: "消息不能为空");
      return;
    }
    MessageEntity? message = await SessionRepository.sendMessage(id, type,
        content: content,
        type: messageType,
        receiveHeadImage: session.value?.headImage,
        receiveNickName: session.value?.name);
    if (message != null) {
      controller.clear();
      list.insert(0, message);
      list.refresh();
      message.sessionId = id;
      MessageRealm(realm: Get.find<RootLogic>().realm).upsert(messageEntityToRealm(message));
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

  Future getImage(ImageSource source) async {
    String? imagePath = await pickerImage(source, cropImage: false);
    if (StringUtil.isNotEmpty(imagePath)) {
      showLoading();
      FileEntity? file = await CommonRepository.uploadImage(imagePath!);
      if (file != null) {
        hiddenLoading();
        await sendImage(file);
      } else {
        showToast(text: "图片上传失败");
        hiddenLoading();
      }
    } else {}
  }

  Future sendImage(FileEntity file) async {
    try {
      String content = json.encode(file.toJson());
      sendMessage(content, MessageType.IMAGE);
    } catch (e) {
      Log.e(e.toString());
    }
  }

  Future sendIdCard(UserEntity? user) async {
    try {
      String content = json.encode(user?.toJson());
      sendMessage(content, MessageType.ID_CARD);
    } catch (e) {
      Log.e(e.toString());
    }
  }

  Future openRedPackage(String? id, String? redPackageId) async {
    String? result = await SessionRepository.checkRedPackage(redPackageId);
    if (result != null) {
      if (result == "Y") {
        Get.toNamed(RoutePath.PACKAGE_RESULT_PAGE, arguments: {Keys.ID: redPackageId});
      } else if (result == "N") {
        showLoading();
        RedPackageBean? result = await SessionRepository.openRedPackage(redPackageId);
        hiddenLoading();
        if (result != null) {
          Get.toNamed(RoutePath.PACKAGE_RESULT_PAGE, arguments: {Keys.ID: redPackageId});
        }
      } else {
        showToast(text: "红包已过期");
      }
    }
  }

  Future sendRedPackage(MessageEntity message) async {
    list.insert(0, message);
    list.refresh();
    if (type == SessionType.private) {
      message.sessionId = id;
      message.receiveHeadImage = session.value?.headImage;
      message.receiveNickName = session.value?.name;
    }
    MessageRealm(realm: Get.find<RootLogic>().realm).upsert(messageEntityToRealm(message));
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

  @override
  void onClose() {
    webSocketManager.removeCallbacks("ChatLogic-$id-$type");
    SessionRepository.readMessage(id, type);
    super.onClose();
  }
}
