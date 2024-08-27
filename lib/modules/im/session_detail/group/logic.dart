import 'package:get/get.dart';
import 'package:vura/base/base_object_logic.dart';
import 'package:vura/entities/base_bean.dart';
import 'package:vura/entities/file_entity.dart';
import 'package:vura/entities/member_entity.dart';
import 'package:vura/entities/session_entity.dart';
import 'package:vura/entities/user_entity.dart';
import 'package:vura/global/enum.dart';
import 'package:vura/global/keys.dart';
import 'package:vura/modules/root/logic.dart';
import 'package:vura/realm/channel.dart';
import 'package:vura/repository/common_repository.dart';
import 'package:vura/repository/session_repository.dart';
import 'package:vura/route/route_path.dart';
import 'package:vura/utils/toast_util.dart';

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
    if (result.code == 200) {}
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
    BaseBean result = await SessionRepository.updateSession(id, notice: notice, name: bean.value?.name);
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
      BaseBean result = await SessionRepository.updateSession(id,
          headImage: file.originUrl, headImageThumb: file.thumbUrl, name: bean.value?.name);
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
