import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vura/application.dart';
import 'package:vura/base/base_list_logic.dart';
import 'package:vura/entities/file_entity.dart';
import 'package:vura/entities/message_entity.dart';
import 'package:vura/entities/package_entity.dart';
import 'package:vura/entities/session_entity.dart';
import 'package:vura/entities/user_entity.dart';
import 'package:vura/global/enum.dart';
import 'package:vura/global/keys.dart';
import 'package:vura/mixin/mute_mixin.dart';
import 'package:vura/mixin/session_detail_mixin.dart';
import 'package:vura/modules/im/session/logic.dart';
import 'package:vura/modules/package/widgets/red_package.dart';
import 'package:vura/modules/root/logic.dart';
import 'package:vura/repository/common_repository.dart';
import 'package:vura/repository/session_repository.dart';
import 'package:vura/route/route_path.dart';
import 'package:vura/utils/enum_to_string.dart';
import 'package:vura/utils/log_utils.dart';
import 'package:vura/utils/message_db_util.dart';
import 'package:vura/utils/session_db_util.dart';
import 'package:vura/utils/sp_util.dart';
import 'package:vura/utils/string_util.dart';
import 'package:vura/utils/toast_util.dart';
import 'package:vura/utils/tool_util.dart';

class ChatLogic extends BaseListLogic<MessageEntity> with SessionDetailMixin, SessionMembersMixin {
  String? id;
  late SessionType type;

  TextEditingController controller = TextEditingController();

  int selectedBgIndex = 0;

  var isVoice = false.obs;

  var messagePlayingId = Rx<String?>(null);

  final _audioPlayer = AudioPlayer();

  var curState = PlayerState.stopped.obs;

  ChatLogic() {
    id = Get.arguments[Keys.ID];
    type = Get.arguments[Keys.TYPE];

    selectedBgIndex = SpUtil.getInt(Keys.CHAT_BG_IMAGE_INDEX, defValue: 0);

    controller.addListener(update);

    webSocketManager.listen("ChatLogic-$id-$type", (int cmd, Map<String, dynamic> data) {
      Log.d("ChatLogic == 》接收到消息: $cmd, 数据: $data");
      if (cmd == WebSocketCode.PRIVATE_MESSAGE.code) {
        if (id == data["sendId"] &&
            (data[Keys.TYPE] < MessageType.RECALL.code ||
                data[Keys.TYPE] == MessageType.TIP_TEXT.code ||
                data[Keys.TYPE] >= MessageType.RED_PACKAGE.code)) {
          list.insert(0, MessageEntity.fromJson(data));
          list.refresh();
        }
      }
      if (cmd == WebSocketCode.GROUP_MESSAGE.code && id == data[Keys.GROUP_ID]) {
        if (data[Keys.TYPE] < MessageType.RECALL.code || data[Keys.TYPE] >= MessageType.RED_PACKAGE.code) {
          if (data["sendId"] == Get.find<RootLogic>().user.value?.id) return;
          list.insert(0, MessageEntity.fromJson(data));
          list.refresh();
        }
        if (data[Keys.TYPE] == MessageType.TIP_TEXT.code) {
          list.insert(0, MessageEntity.fromJson(data));
          list.refresh();
        }

        /// 修改群配置  {"cmd":4,"data":{"addFriend":"N" ,"allMute":"" ,"vura":"N","id":"1829665405703159809","invite":"N","type":300}}
        if (data[Keys.TYPE] == MessageType.UPDATE_GROUP_CONFIG && data[Keys.ID] == id) {
          session.value?.configObj = SessionConfigEntity.fromJson(data);
          session.refresh();
        }

        /// 禁言某人 {"cmd":4,"data":{"groupId":"1829665405703159809", "userId":"1826517087758188544","type":301}}
        if (data[Keys.TYPE] == MessageType.UPDATE_MEMBER_MUTE && data[Keys.GROUP_ID] == id) {
          mute(data[Keys.USER_ID]);
        }

        /// 解除禁言某人 {"cmd":4,"data":{"groupId":"1829665405703159809", "userId":"1826517087758188544","type":302}}
        if (data[Keys.TYPE] == MessageType.UPDATE_MEMBER_UN_MUTE && data[Keys.GROUP_ID] == id) {
          noMute(data[Keys.USER_ID]);
        }
      }
    });

    _audioPlayer
      ..onDurationChanged.listen((Duration duration) {
        Log.d("onDurationChanged========>${duration.toString()}");
      })
      ..onPlayerStateChanged.listen((PlayerState state) {
        Log.d("onPlayerStateChanged========>${state.toString()}");
        curState.value = state;
      })
      ..onPlayerComplete.listen((event) {
        Log.d("onPlayerComplete========>");
        messagePlayingId.value = null;
      })
      ..onPositionChanged.listen((Duration position) {
        Log.d("onPositionChanged========>${position.toString()}");
      });
  }

  @override
  void onInit() {
    getSessionDetail(id, type);
    initData();
    super.onInit();
    if (type == SessionType.group) getMembers(id);
  }

  @override
  Future<List<MessageEntity>> loadData() async {
    return await MessageRealm(realm: Get.find<RootLogic>().realm).queryAllMessageBySessionId(id);
    // return SessionRepository.getMessages(id, type, page: pageNumber.value, size: pageSize.value);
  }

  /// 发送消息
  Future sendMessage(String content, MessageType messageType, {List<String?> ids = const []}) async {
    if (StringUtil.isEmpty(content)) {
      showToast(text: "消息不能为空");
      return;
    }
    MessageEntity? message = await SessionRepository.sendMessage(id, type,
        content: content,
        type: messageType,
        receiveHeadImage: session.value?.headImage,
        receiveNickName: session.value?.name,
        atUserIds: ids);
    if (message != null) {
      controller.clear();
      list.insert(0, message);
      list.refresh();
      message.sessionId = id;
      message.sessionType = type;
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
      ImageEntity? file = await CommonRepository.uploadImage(imagePath!);
      if (file != null) {
        hiddenLoading();
        await sendImage(file);
      } else {
        showToast(text: "图片上传失败");
        hiddenLoading();
      }
    } else {}
  }

  Future sendImage(ImageEntity file) async {
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

  Future openRedPackage(BuildContext context, MessageEntity message, RedPackageEntity redPackage) async {
    if (type == SessionType.private && redPackage.type == RedPackageType.SPECIAL.code) {
      updateRedPackageState(message.id);
      Get.toNamed(RoutePath.TRANSFER_RESULT_PAGE, arguments: {Keys.ID: redPackage.id});
    } else {
      /// 单聊，群主，群管理，开启抢红包的个人
      if (type == SessionType.private ||
          session.value?.isAdmin == YorNType.Y ||
          session.value?.isSupAdmin == YorNType.Y ||
          members.firstWhereOrNull((item) => item.userId == Get.find<RootLogic>().user.value?.id)?.isReceiveRedPacket ==
              0) {
        String? result = await SessionRepository.checkRedPackage(redPackage.id);
        if (result != null) {
          if (result == YorNType.Y.name) {
            updateRedPackageState(message.id);
            Get.toNamed(RoutePath.PACKAGE_RESULT_PAGE, arguments: {Keys.ID: redPackage.id});
          } else if (result == YorNType.N.name) {
            if (context.mounted) {
              showRedPacket(context, () {
                updateRedPackageState(message.id);
                Get.toNamed(RoutePath.PACKAGE_RESULT_PAGE, arguments: {Keys.ID: redPackage.id});
              },
                  nickName: message.sendNickName,
                  headImage: message.sendHeadImage,
                  redPackageId: redPackage.id,
                  coverImage: EnumToString.fromString(RedPackageCoverType.values, redPackage.cover,
                          defaultValue: RedPackageCoverType.cover_0)!
                      .itemPath);
            }
          } else if (result == YorNType.F.name) {
            updateRedPackageState(message.id);
            Get.toNamed(RoutePath.PACKAGE_RESULT_PAGE, arguments: {Keys.ID: redPackage.id});
          } else if (result == YorNType.EXPIRE.name) {
            updateRedPackageState(message.id);
            showToast(text: "红包已过期");
            Get.toNamed(RoutePath.PACKAGE_RESULT_PAGE, arguments: {Keys.ID: redPackage.id});
          } else {}
        }
      } else {
        showToast(text: "群主设置了禁止领取VURA");
      }
    }
  }

  void updateRedPackageState(String? id) {
    list.firstWhere((item) => item.id == id).openRedPackage = true;
    list.refresh();
    MessageRealm(realm: Get.find<RootLogic>().realm).updateRedPackageState(id);
  }

  /// 转账给他人
  Future transferToMember(MessageEntity message, UserEntity toUser) async {
    message.sessionId = toUser.id;
    message.receiveHeadImage = toUser.headImage;
    message.receiveNickName = toUser.nickName;
    message.sessionType = SessionType.private;

    MessageRealm(realm: Get.find<RootLogic>().realm).upsert(messageEntityToRealm(message));
    SessionRealm(realm: Get.find<RootLogic>().realm)
        .updateLastMessage(
            SessionEntity(
                id: toUser.id,
                name: toUser.nickName,
                type: SessionType.private,
                headImage: toUser.headImage,
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

  Future sendRedPackage(MessageEntity message) async {
    list.insert(0, message);
    list.refresh();
    if (type == SessionType.private) {
      message.sessionId = id;
      message.receiveHeadImage = session.value?.headImage;
      message.receiveNickName = session.value?.name;
    }
    message.sessionType = type;
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

  Future uploadAudio(String? path, int duration) async {
    if (path != null) {
      showLoading();
      String? fileUrl = await CommonRepository.uploadFile(path);
      if (fileUrl != null) {
        hiddenLoading();
        await sendVoice(fileUrl, duration);
      } else {
        showToast(text: "语音上传失败");
        hiddenLoading();
      }
    }
  }

  Future sendVoice(String fileUrl, int duration) async {
    try {
      String content = json.encode({"fileUrl": fileUrl, "duration": duration});
      sendMessage(content, MessageType.AUDIO);
    } catch (e) {
      Log.e(e.toString());
    }
  }

  /// 播放
  void play(String? url, String? messageId) async {
    Log.d("==============================>$url----------------$messageId");
    if (StringUtil.isEmpty(url) || StringUtil.isEmpty(messageId)) return;
    if (messagePlayingId.value == messageId) {
      if (curState.value == PlayerState.playing) await _audioPlayer.pause();
      if (curState.value == PlayerState.paused) await _audioPlayer.resume();
    } else {
      Log.d("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
      messagePlayingId.value = messageId;
      try {
        if (curState.value == PlayerState.playing) await _audioPlayer.stop();
        await _audioPlayer.play(UrlSource(url!)).then((value) {
          Log.d("开始播放");
        });
      } catch (e) {
        Log.e(e.toString());
      }
    }
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    SessionRealm(realm: Get.find<RootLogic>().realm).updateUnreadCount(id, type);
    webSocketManager.removeCallbacks("ChatLogic-$id-$type");
    SessionRepository.readMessage(id, type);
    super.onClose();
  }
}
