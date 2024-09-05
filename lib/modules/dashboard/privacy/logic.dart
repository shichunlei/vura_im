import 'package:get/get.dart';
import 'package:vura/base/base_logic.dart';
import 'package:vura/entities/base_bean.dart';
import 'package:vura/global/enum.dart';
import 'package:vura/modules/root/logic.dart';
import 'package:vura/repository/user_repository.dart';
import 'package:vura/route/route_path.dart';
import 'package:vura/utils/sp_util.dart';

class PrivacyLogic extends BaseLogic {
  String? id;

  var loginProtect = false.obs;

  PrivacyLogic() {
    id = Get.find<RootLogic>().user.value?.id;
    loginProtect.value = SpUtil.getBool("_login_protect_", defValue: false);
  }

  Future setVura(bool value) async {
    showLoading();
    BaseBean result = await UserRepository.updateUserConfig(id, vura: value ? YorNType.Y : YorNType.N);
    hiddenLoading();
    if (result.code == 200) {
      Get.find<RootLogic>().updateVura(value ? YorNType.Y : YorNType.N);
    }
  }

  Future setSearch(bool value) async {
    showLoading();
    BaseBean result = await UserRepository.updateUserConfig(id, search: value ? YorNType.Y : YorNType.N);
    hiddenLoading();
    if (result.code == 200) {
      Get.find<RootLogic>().updateSearch(value ? YorNType.Y : YorNType.N);
    }
  }

  Future setSetGroup(bool value) async {
    showLoading();
    BaseBean result = await UserRepository.updateUserConfig(id, setGroup: value ? YorNType.Y : YorNType.N);
    hiddenLoading();
    if (result.code == 200) {
      Get.find<RootLogic>().updateSetGroup(value ? YorNType.Y : YorNType.N);
    }
  }

  Future setProtect(bool value) async {
    // showLoading();
    // BaseBean result = await UserRepository.updateUserConfig(id, protect: value ? YorNType.Y : YorNType.N);
    // hiddenLoading();
    // if (result.code == 200) {
    //   Get.find<RootLogic>().updateProtect(value ? YorNType.Y : YorNType.N);
    // }
    if (value) {
      // 如果没有设置任何锁屏密码则提示用户先设置锁屏密码，设置完后直接打开登录保护
    }
    loginProtect.value = value;
    SpUtil.setBool("_login_protect_", value);

    if (value) {
      Get.toNamed(RoutePath.LOCK_SCREEN_PASSWORD_PAGE);
    }
  }

  Future setAddFriend(bool value) async {
    showLoading();
    BaseBean result = await UserRepository.updateUserConfig(id, addFriend: value ? YorNType.Y : YorNType.N);
    hiddenLoading();
    if (result.code == 200) {
      Get.find<RootLogic>().updateAddFriend(value ? YorNType.Y : YorNType.N);
    }
  }
}
