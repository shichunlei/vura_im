import 'package:get/get.dart';
import 'package:vura/base/base_logic.dart';
import 'package:vura/global/keys.dart';
import 'package:vura/modules/home/logic.dart';
import 'package:vura/utils/log_utils.dart';
import 'package:vura/utils/sp_util.dart';

class LockScreenPasswordLogic extends BaseLogic {
  var time = 0.obs;

  var gesturePassword = "".obs;

  var numberPassword = "".obs;

  LockScreenPasswordLogic() {
    int lockScreenTime = SpUtil.getInt(Keys.LOCK_SCREEN_TIME, defValue: 0);
    time.value = (lockScreenTime / 1000 / 60).floor();
    refreshPassword();
  }

  void refreshPassword() {
    gesturePassword.value = SpUtil.getString(Keys.GESTURE_PASSWORD, defValue: "");
    numberPassword.value = SpUtil.getString(Keys.NUMBER_PASSWORD, defValue: "");
  }

  void setTime(int value) {
    time.value = value;
    SpUtil.setInt(Keys.LOCK_SCREEN_TIME, value * 60 * 1000);
    try {
      Get.find<HomeLogic>().updateLockScreenTime(value * 60 * 1000);
    } catch (e) {
      Log.e(e.toString());
    }
  }
}
