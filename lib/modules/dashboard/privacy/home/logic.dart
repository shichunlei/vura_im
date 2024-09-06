import 'package:get/get.dart';
import 'package:vura/base/base_logic.dart';
import 'package:vura/entities/base_bean.dart';
import 'package:vura/global/enum.dart';
import 'package:vura/global/keys.dart';
import 'package:vura/modules/home/logic.dart';
import 'package:vura/modules/root/logic.dart';
import 'package:vura/repository/user_repository.dart';
import 'package:vura/utils/dialog_util.dart';
import 'package:vura/utils/log_utils.dart';
import 'package:vura/utils/sp_util.dart';
import 'package:vura/utils/string_util.dart';
import 'package:vura/widgets/dialog/tip_dialog.dart';

class PrivacyLogic extends BaseLogic {
  String? id;

  var loginProtect = false.obs;

  PrivacyLogic() {
    id = Get.find<RootLogic>().user.value?.id;
    loginProtect.value = SpUtil.getBool(Keys.LOGIN_PROTECT, defValue: false);
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

    // 如果没有设置任何锁屏密码则提示用户先设置锁屏密码，设置完后直接打开登录保护
    String gesturePassword = SpUtil.getString(Keys.GESTURE_PASSWORD, defValue: "");
    String numberPassword = SpUtil.getString(Keys.NUMBER_PASSWORD, defValue: "");
    if (StringUtil.isEmpty(gesturePassword) && StringUtil.isEmpty(numberPassword) && value) {
      show(builder: (_) {
        return const CustomTipDialog(title: "温馨提示", content: "请先设置锁屏密码");
      });
      return;
    }

    if (value) {
      int lockScreenTime = SpUtil.getInt(Keys.LOCK_SCREEN_TIME, defValue: 0);
      // 如果打开登录保护时，锁屏时间没有设置，则默认设置为1分钟
      if (lockScreenTime == 0) {
        SpUtil.setInt(Keys.LOCK_SCREEN_TIME, 60 * 1000);
        try {
          Get.find<HomeLogic>().updateLockScreenTime(60 * 1000);
        } catch (e) {
          Log.e(e.toString());
        }
      }
    }

    loginProtect.value = value;
    SpUtil.setBool(Keys.LOGIN_PROTECT, value);

    try {
      Get.find<HomeLogic>().updateLoginProtect(value);
    } catch (e) {
      Log.e(e.toString());
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
