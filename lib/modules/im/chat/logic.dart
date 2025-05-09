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
import 'package:vura/modules/im/widgets/at_text.dart';
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
  String? title;

  TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();

  final MySpecialTextSpanBuilder mySpecialTextSpanBuilder = MySpecialTextSpanBuilder();

  int selectedBgIndex = 0;

  var isVoice = false.obs;

  var messagePlayingId = Rx<String?>(null);

  var atUserIds = RxList<String?>([]);

  final _audioPlayer = AudioPlayer();

  var curState = PlayerState.stopped.obs;

  ChatLogic() {
    id = Get.arguments[Keys.ID];
    type = Get.arguments[Keys.TYPE];
    title = Get.arguments[Keys.TITLE];

    selectedBgIndex = SpUtil.getInt(Keys.CHAT_BG_IMAGE_INDEX, defValue: 0);

    controller.addListener(update);

    webSocketManager.listen("ChatLogic-$id-$type", (int cmd, Map<String, dynamic> data) {
      if (cmd == WebSocketCode.PRIVATE_MESSAGE.code) {
        if (id == data["sendId"] &&
            (data[Keys.TYPE] < MessageType.RECALL.code ||
                data[Keys.TYPE] == MessageType.TIP_TEXT.code ||
                data[Keys.TYPE] == MessageType.PRIVATE_RED_PACKET_TIP_TEXT.code ||
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
        if (data[Keys.TYPE] == MessageType.TIP_TEXT.code ||
            data[Keys.TYPE] == MessageType.GROUP_RED_PACKET_TIP_TEXT.code) {
          list.insert(0, MessageEntity.fromJson(data));
          list.refresh();
        }

        /// 修改群配置  {"cmd":4,"data":{"groupId":"1829665405703159809", "addFriend":"N" ,"allMute":"" ,"vura":"N","id":"1829665405703159809","invite":"N","type":300}}
        if (data[Keys.TYPE] == MessageType.UPDATE_GROUP_CONFIG.code) {
          session.value?.configObj = SessionConfigEntity.fromJson(data);
          session.refresh();
        }

        /// 禁言某人 {"cmd":4,"data":{"groupId":"1829665405703159809", "userId":"1826517087758188544","type":301}}
        if (data[Keys.TYPE] == MessageType.UPDATE_MEMBER_MUTE.code) {
          mute("${data[Keys.USER_ID]}");
        }

        /// 解除禁言某人 {"cmd":4,"data":{"groupId":"1829665405703159809", "userId":"1826517087758188544","type":302}}
        if (data[Keys.TYPE] == MessageType.UPDATE_MEMBER_UN_MUTE.code) {
          noMute("${data[Keys.USER_ID]}");
        }

        /// 群踢人 {"cmd":4,"data":{"groupId":"1829665405703159809", "userIds": ["1826517087758188544"], "type":306}}
        if (data[Keys.TYPE] == MessageType.REMOVE_MEMBERS_FROM_GROUP.code) {
          removeMembers(id, (data["userIds"] as List).map((item) => item.toString()).toList());
        }

        /// 群加人 {"cmd":4,"data":{"groupId":"1829665405703159809", "userIds": ["1826517087758188544"], "type":307}}
        if (data[Keys.TYPE] == MessageType.ADD_MEMBERS_TO_GROUP.code) getMembers(id);

        /// 退群 {"cmd":4,"data":{"groupId":"1829665405703159809", "userId":"1826517087758188544", "type":309}}
        if (data[Keys.TYPE] == MessageType.LEAVE_GROUP.code) removeMember(id, "${data[Keys.USER_ID]}");

        /// 解散群聊 {"cmd":4,"data":{"groupId":"1829665405703159809", "type":308}}
        if (data[Keys.TYPE] == MessageType.DISSOLUTION_GROUP.code) {
          /// 删除本地群聊
          SessionRealm(realm: Get.find<RootLogic>().realm).deleteChannel(id, SessionType.group);
          Get.until((route) => route.settings.name == RoutePath.HOME_PAGE);
        }

        /// 设置管理员 {"cmd":4,"data":{"groupId":"1829665405703159809", "userIds": ["1826517087758188544"], "type":303}}
        if (data[Keys.TYPE] == MessageType.SET_SUP_ADMIN.code) {
          setSupAdmin((data["userIds"] as List).map((item) => item.toString()).toList());
        }

        /// 取消管理员 {"cmd":4,"data":{"groupId":"1829665405703159809", "userIds": ["1826517087758188544"], "type":304}}
        if (data[Keys.TYPE] == MessageType.REMOVE_SUP_ADMIN.code) {
          resetSupAdmin((data["userIds"] as List).map((item) => item.toString()).toList());
        }

        /// 群主换让 {"cmd":4,"data":{"groupId":"1829665405703159809", "userId":"1826517087758188544","type":305}}
        if (data[Keys.TYPE] == MessageType.TRANSFER_ADMIN.code) {}
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
  Future sendMessage(String content, MessageType messageType) async {
    if (StringUtil.isEmpty(content)) {
      showToast(text: "消息不能为空");
      return;
    }
    if (atUserIds.isNotEmpty && StringUtil.isNotEmpty(controller.text)) {
      // 校验被@的用户是否一致
      for (var item in atUserIds) {
        if (members.any((member) => member.userId == item)) {
          if (!controller.text.contains("@${members.firstWhere((member) => member.userId == item).showNickName} ")) {
            atUserIds.remove(item);
          }
        }
      }
    } else {
      atUserIds.clear();
    }

    MessageEntity? message = await SessionRepository.sendMessage(id, type,
        content: content,
        type: messageType,
        receiveHeadImage: session.value?.headImage,
        receiveNickName: session.value?.name,
        atUserIds: atUserIds);
    atUserIds.clear();
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
                  0 &&
              session.value?.configObj?.vura == YorNType.N) {
        String? result = await SessionRepository.checkRedPackage(redPackage.id);
        if (result != null) {
          if (result == YorNType.Y.name) {
            updateRedPackageState(message.id);
            Get.toNamed(RoutePath.PACKAGE_RESULT_PAGE, arguments: {Keys.ID: redPackage.id});
          } else if (result == YorNType.N.name) {
            if (context.mounted) {
              showRedPacket(context, () {
                updateRedPackageState(message.id);
                try {
                  Get.find<RootLogic>().refreshUserInfo();
                } catch (e) {
                  Log.e(e.toString());
                }
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
    MessageRealm(realm: Get.find<RootLogic>().realm).updateRedPackageState(id, this.id);
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
