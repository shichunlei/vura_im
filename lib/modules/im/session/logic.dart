import 'package:get/get.dart';
import 'package:vura/application.dart';
import 'package:vura/base/base_list_logic.dart';
import 'package:vura/entities/base_bean.dart';
import 'package:vura/entities/message_entity.dart';
import 'package:vura/entities/session_entity.dart';
import 'package:vura/entities/user_entity.dart';
import 'package:vura/global/config.dart';
import 'package:vura/global/enum.dart';
import 'package:vura/global/keys.dart';
import 'package:vura/modules/root/logic.dart';
import 'package:vura/realm/channel.dart';
import 'package:vura/realm/friend.dart';
import 'package:vura/repository/session_repository.dart';
import 'package:vura/utils/log_utils.dart';
import 'package:vura/utils/string_util.dart';
import 'package:vura/utils/toast_util.dart';

class SessionLogic extends BaseListLogic<SessionEntity> {
  var loadingGroupMessages = false.obs;
  var loadingPrivateMessages = false.obs;

  SessionLogic() {
    webSocketManager.listen("SessionLogic", (int cmd, Map<String, dynamic> data) async {
      Log.d("SessionLogic == 》接收到消息: $cmd, 数据: $data");
      if (cmd == WebSocketCode.PRIVATE_MESSAGE.code) {
        if (data[Keys.TYPE] == MessageType.LOADING.code) {
          if (data[Keys.CONTENT] == "true") loadingPrivateMessages.value = true;
          if (data[Keys.CONTENT] == "false") {
            loadingPrivateMessages.value = false;
            refreshList();
          }
        } else {
          MessageEntity message = MessageEntity.fromJson(data);
          String? myUserId = AppConfig.userId;
          String? id;
          String? headImage;
          String? name;
          if (message.sendId != myUserId) {
            id = message.sendId;
            headImage = message.sendHeadImage;
            if (StringUtil.isEmpty(message.sendNickName)) {
              name = await FriendRealm(realm: Get.find<RootLogic>().realm).queryFriendNicknameById(id);
            } else {
              name = message.sendNickName;
            }
          }
          if (message.receiveId != myUserId) {
            id = message.receiveId;
            headImage = message.receiveHeadImage;
            if (StringUtil.isEmpty(message.receiveNickName)) {
              name = await FriendRealm(realm: Get.find<RootLogic>().realm).queryFriendNicknameById(id);
            } else {
              name = message.receiveNickName;
            }
          }

          SessionRealm(realm: Get.find<RootLogic>().realm)
              .updateLastMessage(
                  SessionEntity(
                      id: id,
                      name: name,
                      type: SessionType.private,
                      headImage: headImage,
                      lastMessage: message,
                      lastMessageTime: message.sendTime),
                  message)
              .then((value) {
            if (!loadingPrivateMessages.value) refreshList();
          });
        }
      }
      if (cmd == WebSocketCode.GROUP_MESSAGE.code) {
        if (data[Keys.TYPE] == MessageType.LOADING.code) {
          if (data[Keys.CONTENT] == "true") loadingGroupMessages.value = true;
          if (data[Keys.CONTENT] == "false") {
            loadingGroupMessages.value = false;
            refreshList();
          }
        } else {
          MessageEntity message = MessageEntity.fromJson(data);
          SessionRealm(realm: Get.find<RootLogic>().realm)
              .updateLastMessage(
                  SessionEntity(
                      id: message.groupId,
                      type: SessionType.group,
                      lastMessage: message,
                      lastMessageTime: message.sendTime),
                  message)
              .then((value) {
            if (!loadingGroupMessages.value) refreshList();
          });
        }
      }
    });
  }

  @override
  void onInit() {
    initData();
    super.onInit();
  }

  bool loadFromNet = false;

  @override
  Future<List<SessionEntity>> loadData() async {
    if (Get.find<RootLogic>().user.value == null) {
      loadFromNet = true;
      return await SessionRepository.getSessionList();
    }
    return await SessionRealm(realm: Get.find<RootLogic>().realm).queryAllSessions();
  }

  @override
  void onCompleted(List<SessionEntity> data) {
    if (!loadFromNet) loadSessionsFromNet();
  }

  Future createSession(List<UserEntity> users) async {
    Map<String, dynamic> params = {};

    params["name"] = users.map((item) => item.nickName).toList().join(",");
    params["ownerId"] = Get.find<RootLogic>().user.value?.id;
    params["remarkNickName"] = Get.find<RootLogic>().user.value?.nickName;
    params["showNickName"] = Get.find<RootLogic>().user.value?.nickName;
    params["showGroupName"] = "";
    params["remarkGroupName"] = "";
    params['headImage'] = "";
    params['headImageThumb'] = "";
    params['isAdmin'] = true;
    params["friendIds"] = users.map((item) => item.id).toList();

    showLoading();
    BaseBean result = await SessionRepository.createSession(params);
    hiddenLoading();

    if (result.code == 200) {
      showToast(text: "创建成功");
      loadSessionsFromNet();
    }
  }

  void loadSessionsFromNet() async {
    List<SessionEntity> sessions = await SessionRepository.getSessionList();
    if (sessions.isNotEmpty) {
      for (var item in sessions) {
        item.type = SessionType.group;
        await SessionRealm(realm: Get.find<RootLogic>().realm).saveChannel(item);
      }
      refreshList();
    }
  }

  void refreshList() async {
    list.value = await SessionRealm(realm: Get.find<RootLogic>().realm).queryAllSessions();
    list.refresh();
  }

  Future setTop(int index) async {
    list[index].moveTop = !list[index].moveTop;
    list.refresh();
    await SessionRealm(realm: Get.find<RootLogic>().realm)
        .setChannelTop(list[index].id, list[index].moveTop, list[index].type);
  }

  Future setDisturb(int index) async {
    list[index].isDisturb = !list[index].isDisturb;
    list.refresh();
    await SessionRealm(realm: Get.find<RootLogic>().realm)
        .setChannelDisturb(list[index].id, list[index].isDisturb, list[index].type);
  }

  @override
  void onClose() {
    webSocketManager.removeCallbacks("SessionLogic");
    super.onClose();
  }
}
