import 'package:get/get.dart';
import 'package:im/base/base_list_logic.dart';
import 'package:im/entities/message_entity.dart';
import 'package:im/entities/session_entity.dart';
import 'package:im/entities/user_entity.dart';
import 'package:im/global/enum.dart';
import 'package:im/global/keys.dart';
import 'package:im/modules/home/logic.dart';
import 'package:im/modules/root/logic.dart';
import 'package:im/realm/session.dart';
import 'package:im/repository/session_repository.dart';
import 'package:im/utils/log_utils.dart';
import 'package:im/utils/toast_util.dart';

class SessionLogic extends BaseListLogic<SessionEntity> {
  var loadingGroupMessages = false.obs;
  var loadingPrivateMessages = false.obs;

  SessionLogic() {
    webSocketManager
      ..setOnConnectCallback(() {
        Log.d("WebSocket 连接成功");

        /// 拉取离线消息
        SessionRepository.getOfflineMessages("all", groupMinId: 0, privateMinId: 0);
      })
      ..setOnMessageCallback((int cmd, Map<String, dynamic> data) {
        if (cmd == WebSocketCode.PRIVATE_MESSAGE.code) {
          if (data[Keys.TYPE] == MessageType.LOADING.code) {
            if (data[Keys.CONTENT] == "true") loadingPrivateMessages.value = true;
            if (data[Keys.CONTENT] == "false") {
              loadingPrivateMessages.value = false;
              refreshList();
            }
          } else {
            Log.d("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");

            int? myUserId = Get.find<RootLogic>().user.value?.id;
            int? id;
            if (data["sendId"] != myUserId) id = data["sendId"];
            if (data["recvId"] != myUserId) id = data["recvId"];

            SessionRealm(realm: Get.find<RootLogic>().realm)
                .updateLastMessage(SessionEntity(id: id, name: "这个是单聊", type: "private"), MessageEntity.fromJson(data))
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
            SessionRealm(realm: Get.find<RootLogic>().realm)
                .updateLastMessage(SessionEntity(id: data["groupId"], type: "group"), MessageEntity.fromJson(data))
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

  @override
  Future<List<SessionEntity>> loadData() async {
    if (Get.find<RootLogic>().user.value == null) {
      return await SessionRepository.getSessionList();
    }
    return await SessionRealm(realm: Get.find<RootLogic>().realm).queryAllSessions();
  }

  @override
  void onCompleted(List<SessionEntity> data) {
    loadSessionsFromNet();
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

    showLoading();
    SessionEntity? session = await SessionRepository.createSession(params, users.map((item) => item.id).toList());
    hiddenLoading();

    if (session != null) {
      showToast(text: "创建成功");
      refreshData();
    }
  }

  void loadSessionsFromNet() async {
    List<SessionEntity> sessions = await SessionRepository.getSessionList();
    if (sessions.isNotEmpty) {
      for (var item in sessions) {
        item.type = "group";
        await SessionRealm(realm: Get.find<RootLogic>().realm).upsert(sessionEntityToRealm(item));
      }
      refreshList();
    }
  }

  void refreshList() async {
    list.value = await SessionRealm(realm: Get.find<RootLogic>().realm).queryAllSessions();
    list.refresh();
  }
}
