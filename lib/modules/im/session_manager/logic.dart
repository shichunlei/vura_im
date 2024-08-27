import 'package:get/get.dart';
import 'package:vura/base/base_object_logic.dart';
import 'package:vura/entities/base_bean.dart';
import 'package:vura/entities/session_entity.dart';
import 'package:vura/global/enum.dart';
import 'package:vura/global/keys.dart';
import 'package:vura/modules/root/logic.dart';
import 'package:vura/realm/channel.dart';
import 'package:vura/repository/session_repository.dart';
import 'package:vura/utils/toast_util.dart';

class SessionManagerLogic extends BaseObjectLogic<SessionConfigEntity?> {
  String? id;

  SessionManagerLogic() {
    id = Get.arguments[Keys.ID];
  }

  @override
  void onInit() {
    initData();
    super.onInit();
  }

  @override
  Future<SessionConfigEntity?> loadData() async {
    return SessionRepository.getSessionConfig(id);
  }

  Future updateAllMuteConfig(bool value) async {
    bean.value!.allMute = value ? YorNType.Y : YorNType.N;
    showLoading();
    BaseBean config = await SessionRepository.setSessionConfig(bean.value!);
    hiddenLoading();
    if (config.code == 200) {
      showToast(text: "设置成功");
      bean.refresh();
      await SessionRealm(realm: Get.find<RootLogic>().realm).setChannelConfig(id, bean.value!);
    }
  }

  Future updateAddFriendConfig(bool value) async {
    bean.value!.addFriend = value ? YorNType.Y : YorNType.N;
    showLoading();
    BaseBean config = await SessionRepository.setSessionConfig(bean.value!);
    hiddenLoading();
    if (config.code == 200) {
      showToast(text: "设置成功");
      bean.refresh();
      await SessionRealm(realm: Get.find<RootLogic>().realm).setChannelConfig(id, bean.value!);
    }
  }

  Future updateVuraConfig(bool value) async {
    bean.value!.vura = value ? YorNType.Y : YorNType.N;
    showLoading();
    BaseBean config = await SessionRepository.setSessionConfig(bean.value!);
    hiddenLoading();
    if (config.code == 200) {
      showToast(text: "设置成功");
      bean.refresh();
      await SessionRealm(realm: Get.find<RootLogic>().realm).setChannelConfig(id, bean.value!);
    }
  }

  Future updateInviteConfig(bool value) async {
    bean.value!.invite = value ? YorNType.Y : YorNType.N;
    showLoading();
    BaseBean config = await SessionRepository.setSessionConfig(bean.value!);
    hiddenLoading();
    if (config.code == 200) {
      showToast(text: "设置成功");
      bean.refresh();
      await SessionRealm(realm: Get.find<RootLogic>().realm).setChannelConfig(id, bean.value!);
    }
  }
}
