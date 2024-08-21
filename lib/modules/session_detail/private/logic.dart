import 'package:get/get.dart';
import 'package:im/base/base_object_logic.dart';
import 'package:im/entities/base_bean.dart';
import 'package:im/entities/session_entity.dart';
import 'package:im/global/enum.dart';
import 'package:im/global/keys.dart';
import 'package:im/modules/home/session/logic.dart';
import 'package:im/modules/root/logic.dart';
import 'package:im/realm/channel.dart';
import 'package:im/realm/friend.dart';
import 'package:im/repository/contacts_repository.dart';
import 'package:im/route/route_path.dart';
import 'package:im/utils/log_utils.dart';

class PrivateSessionDetailLogic extends BaseObjectLogic<SessionEntity?> {
  int? id;

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
    return await SessionRealm(realm: Get.find<RootLogic>().realm).querySessionById(id, SessionType.private);
  }

  Future setTop(bool value) async {
    bean.value!.moveTop = value;
    bean.refresh();
    await SessionRealm(realm: Get.find<RootLogic>().realm).setChannelTop(id, value, SessionType.private).then((item) {
      try {
        Get.find<SessionLogic>().refreshList();
      } catch (e) {
        Log.e(e.toString());
      }
    });
  }

  Future setDisturb(bool value) async {
    bean.value!.isDisturb = value;
    bean.refresh();
    await SessionRealm(realm: Get.find<RootLogic>().realm)
        .setChannelDisturb(id, value, SessionType.private)
        .then((item) {
      try {
        Get.find<SessionLogic>().refreshList();
      } catch (e) {
        Log.e(e.toString());
      }
    });
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
      /// 删除群聊
      SessionRealm(realm: Get.find<RootLogic>().realm).deleteChannel(id, SessionType.private);

      /// 删除好友
      FriendRealm(realm: Get.find<RootLogic>().realm).deleteFriend(id);

      Get.until((route) => route.settings.name == RoutePath.HOME_PAGE);
    }
  }
}
