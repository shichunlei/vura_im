import 'package:vura/application.dart';
import 'package:vura/base/base_list_logic.dart';
import 'package:vura/entities/base_bean.dart';
import 'package:vura/entities/session_entity.dart';
import 'package:vura/entities/user_entity.dart';
import 'package:vura/global/enum.dart';
import 'package:vura/mixin/receive_message_mixin.dart';
import 'package:vura/repository/session_repository.dart';
import 'package:vura/utils/session_db_util.dart';
import 'package:vura/utils/string_util.dart';
import 'package:vura/utils/toast_util.dart';

class SessionLogic extends BaseListLogic<SessionEntity> with ReceiveMessageMixin {
  SessionLogic() {
    receiveMessageListener("SessionLogic");
  }

  @override
  void onInit() {
    initData();
    super.onInit();
  }

  @override
  Future<List<SessionEntity>> loadData() async {
    return await SessionRealm(realm: rootLogic.realm).queryAllSessions();
  }

  @override
  void onCompleted(List<SessionEntity> data) {
    loadSessionsFromNet();
  }

  Future createSession(List<UserEntity> users) async {
    Map<String, dynamic> params = {};

    params["name"] = StringUtil.truncateString(users.map((item) => item.nickName).toList().join(","));
    params["ownerId"] = rootLogic.user.value?.id;
    params["remarkNickName"] = rootLogic.user.value?.nickName;
    params["showNickName"] = rootLogic.user.value?.nickName;
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
        await SessionRealm(realm: rootLogic.realm).saveChannel(item, refreshList: false);
      }
      refreshList();
    }
  }

  void refreshList() async {
    list.value = await SessionRealm(realm: rootLogic.realm).queryAllSessions();
    list.refresh();
  }

  Future setTop(int index) async {
    list[index].moveTop = !list[index].moveTop;
    list.refresh();
    await SessionRealm(realm: rootLogic.realm).setChannelTop(list[index].id, list[index].moveTop, list[index].type);
  }

  Future setDisturb(int index) async {
    list[index].isDisturb = !list[index].isDisturb;
    list.refresh();
    await SessionRealm(realm: rootLogic.realm)
        .setChannelDisturb(list[index].id, list[index].isDisturb, list[index].type);
  }

  Future removeSession(int index) async {
    await SessionRealm(realm: rootLogic.realm).removeChannel(list[index].id, list[index].type);
    list.removeAt(index);
    list.refresh();
  }

  /// 退出群聊
  Future quitSession(String? id) async {
    showLoading();
    BaseBean result = await SessionRepository.quitSession(id);
    hiddenLoading();
    if (result.code == 200) {
      /// 删除本地群聊
      SessionRealm(realm: rootLogic.realm).quitChannel(id, SessionType.group);
    }
  }

  /// 解散群聊
  Future deleteSession(String? id) async {
    showLoading();
    BaseBean result = await SessionRepository.deleteSession(id);
    hiddenLoading();
    if (result.code == 200) {
      /// 删除本地群聊
      SessionRealm(realm: rootLogic.realm).deleteChannel(id, SessionType.group);
    }
  }

  @override
  void onClose() {
    webSocketManager.removeCallbacks("SessionLogic");
    super.onClose();
  }
}
