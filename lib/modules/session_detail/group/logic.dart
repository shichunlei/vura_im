import 'package:get/get.dart';
import 'package:im/base/base_object_logic.dart';
import 'package:im/entities/base_bean.dart';
import 'package:im/entities/file_entity.dart';
import 'package:im/entities/member_entity.dart';
import 'package:im/entities/session_entity.dart';
import 'package:im/entities/user_entity.dart';
import 'package:im/global/enum.dart';
import 'package:im/global/keys.dart';
import 'package:im/modules/home/session/logic.dart';
import 'package:im/modules/root/logic.dart';
import 'package:im/realm/channel.dart';
import 'package:im/repository/common_repository.dart';
import 'package:im/repository/session_repository.dart';
import 'package:im/route/route_path.dart';
import 'package:im/utils/log_utils.dart';
import 'package:im/utils/toast_util.dart';

class GroupSessionDetailLogic extends BaseObjectLogic<SessionEntity?> {
  String? id;

  GroupSessionDetailLogic() {
    id = Get.arguments[Keys.ID];
  }

  @override
  void onInit() {
    initData();
    super.onInit();
    getMembers();
  }

  @override
  Future<SessionEntity?> loadData() async {
    return await SessionRealm(realm: Get.find<RootLogic>().realm).querySessionById(id, SessionType.group);
  }

  @override
  void onCompleted(SessionEntity? data) {
    asyncSessionDetail();
  }

  /// 踢人
  Future deleteMembers() async {
    showLoading();
    BaseBean result = await SessionRepository.kickMemberFromSession(id, []);
    hiddenLoading();
  }

  /// 邀请人
  Future inviteMembers(List<UserEntity> users) async {
    showLoading();
    BaseBean result = await SessionRepository.inviteMembers(id, users.map((item) => item.id).toList());
    hiddenLoading();
    if (result.code == 200) getMembers();
  }

  /// 退出群聊
  Future quitSession() async {
    showLoading();
    BaseBean result = await SessionRepository.quitSession(id);
    hiddenLoading();
    if (result.code == 200) {
      /// 删除本地群聊
      SessionRealm(realm: Get.find<RootLogic>().realm).deleteChannel(id, SessionType.group);
      Get.until((route) => route.settings.name == RoutePath.HOME_PAGE);
    }
  }

  /// 解散群聊
  Future deleteSession() async {
    showLoading();
    BaseBean result = await SessionRepository.deleteSession(id);
    hiddenLoading();
    if (result.code == 200) {
      /// 删除本地群聊
      SessionRealm(realm: Get.find<RootLogic>().realm).deleteChannel(id, SessionType.group);
      Get.until((route) => route.settings.name == RoutePath.HOME_PAGE);
    }
  }

  RxList<MemberEntity> members = RxList<MemberEntity>([]);

  Future getMembers() async {
    members.value = await SessionRepository.getSessionMembers(id);
  }

  Future setTop(bool value) async {
    bean.value!.moveTop = value;
    bean.refresh();
    await SessionRealm(realm: Get.find<RootLogic>().realm).setChannelTop(id, value, SessionType.group);
  }

  Future setDisturb(bool value) async {
    bean.value!.isDisturb = value;
    bean.refresh();
    await SessionRealm(realm: Get.find<RootLogic>().realm).setChannelDisturb(id, value, SessionType.group);
  }

  void asyncSessionDetail() async {
    SessionEntity? session = await SessionRepository.getSessionInfo(id);
    if (session != null) {
      await SessionRealm(realm: Get.find<RootLogic>().realm).updateSessionInfo(session).then((value) async {
        bean.value = await SessionRealm(realm: Get.find<RootLogic>().realm).querySessionById(id, SessionType.group);
        bean.refresh();
        try {
          Get.find<SessionLogic>().refreshList();
        } catch (e) {
          Log.e(e.toString());
        }
      });
    }
  }

  Future updateName(String name) async {
    showLoading();
    BaseBean result = await SessionRepository.updateSession(id, name: name);
    hiddenLoading();
    if (result.code == 200) {
      showToast(text: "修改成功");
      bean.value?.name = name;
      bean.refresh();

      await SessionRealm(realm: Get.find<RootLogic>().realm).updateSessionInfo(SessionEntity(
          id: id,
          type: SessionType.group,
          name: name,
          headImage: bean.value?.headImage,
          headImageThumb: bean.value?.headImageThumb));
    }
  }

  Future updateNotice(String notice) async {
    showLoading();
    BaseBean result = await SessionRepository.updateSession(id, notice: notice);
    hiddenLoading();
    if (result.code == 200) {
      showToast(text: "修改成功");
      bean.value?.notice = notice;
      bean.refresh();

      await SessionRealm(realm: Get.find<RootLogic>().realm).updateSessionInfo(SessionEntity(
          id: id,
          type: SessionType.group,
          name: bean.value?.name,
          notice: notice,
          headImage: bean.value?.headImage,
          headImageThumb: bean.value?.headImageThumb));
    }
  }

  Future updateAvatar(String path) async {
    showLoading();
    FileEntity? file = await CommonRepository.uploadImage(path);
    if (file != null) {
      BaseBean result =
          await SessionRepository.updateSession(id, headImage: file.originUrl, headImageThumb: file.thumbUrl);
      hiddenLoading();
      if (result.code == 200) {
        showToast(text: "修改成功");
        bean.value?.headImage = file.originUrl;
        bean.value?.headImageThumb = file.thumbUrl;
        bean.refresh();
        await SessionRealm(realm: Get.find<RootLogic>().realm).updateSessionInfo(SessionEntity(
            id: id,
            type: SessionType.group,
            name: bean.value?.name,
            headImage: file.originUrl,
            headImageThumb: file.thumbUrl));
      }
    } else {
      hiddenLoading();
    }
  }
}
