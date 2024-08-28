import 'package:get/get.dart';
import 'package:vura/base/base_object_logic.dart';
import 'package:vura/entities/base_bean.dart';
import 'package:vura/entities/session_entity.dart';
import 'package:vura/entities/user_entity.dart';
import 'package:vura/global/enum.dart';
import 'package:vura/global/keys.dart';
import 'package:vura/modules/contacts/home/logic.dart';
import 'package:vura/modules/root/logic.dart';
import 'package:vura/realm/channel.dart';
import 'package:vura/realm/friend.dart';
import 'package:vura/repository/contacts_repository.dart';
import 'package:vura/repository/user_repository.dart';
import 'package:vura/route/route_path.dart';
import 'package:vura/utils/log_utils.dart';

class PrivateSessionDetailLogic extends BaseObjectLogic<SessionEntity?> {
  String? id;

  PrivateSessionDetailLogic() {
    id = Get.arguments[Keys.ID];
  }

  @override
  void onInit() {
    initData();
    super.onInit();
  }

  @override
  Future<SessionEntity?> loadData() async {
    UserEntity? user = await UserRepository.getUserInfoById(id);
    if (user != null) {
      await SessionRealm(realm: Get.find<RootLogic>().realm).updateSessionInfo(SessionEntity(
          id: user.id,
          type: SessionType.private,
          name: user.nickName,
          headImage: user.headImage,
          headImageThumb: user.headImageThumb));
    }
    return await SessionRealm(realm: Get.find<RootLogic>().realm).querySessionById(id, SessionType.private);
  }

  Future setTop(bool value) async {
    bean.value!.moveTop = value;
    bean.refresh();
    await SessionRealm(realm: Get.find<RootLogic>().realm).setChannelTop(id, value, SessionType.private);
  }

  Future setDisturb(bool value) async {
    bean.value!.isDisturb = value;
    bean.refresh();
    await SessionRealm(realm: Get.find<RootLogic>().realm).setChannelDisturb(id, value, SessionType.private);
  }

  /// 删除好友
  Future deleteFriend() async {
    showLoading();
    BaseBean result = await ContactsRepository.deleteFriend(id);
    hiddenLoading();
    if (result.code == 200) {
      /// 删除群聊
      SessionRealm(realm: Get.find<RootLogic>().realm).deleteChannel(id, SessionType.private);

      /// 删除好友
      FriendRealm(realm: Get.find<RootLogic>().realm).deleteFriend(id);

      Get.until((route) => route.settings.name == RoutePath.HOME_PAGE);
    }
  }

  /// 加入黑名单
  Future addBlacklist() async {
    showLoading();
    BaseBean result = await ContactsRepository.addFriendToBlack(id);
    hiddenLoading();
    if (result.code == 200) {
      bean.value?.friendship = YorNType.B;
      bean.refresh();

      /// 删除群聊
      SessionRealm(realm: Get.find<RootLogic>().realm).blacklistChannel(id, YorNType.B);

      /// 删除好友
      FriendRealm(realm: Get.find<RootLogic>().realm).deleteFriend(id);

      // Get.until((route) => route.settings.name == RoutePath.HOME_PAGE);
    }
  }

  /// 移除黑名单
  Future removeFromBlacklist() async {
    showLoading();
    BaseBean result = await ContactsRepository.removeFriendFromBlack(id);
    hiddenLoading();
    if (result.code == 200) {
      bean.value?.friendship = YorNType.Y;
      bean.refresh();
      try {
        Get.find<ContactsLogic>().refreshData();
      } catch (e) {
        Log.e(e.toString());
      }
    }

    SessionRealm(realm: Get.find<RootLogic>().realm).blacklistChannel(id, YorNType.Y);
  }

  Future updateRemarkName(String remark) async {
    showLoading();
    BaseBean result = await ContactsRepository.updateFriend(id, nickName: remark);
    hiddenLoading();
    if (result.code == 200) {}
  }
}
