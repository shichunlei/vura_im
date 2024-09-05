import 'package:get/get.dart';
import 'package:vura/base/base_logic.dart';
import 'package:vura/utils/sp_util.dart';

class LockScreenPasswordLogic extends BaseLogic {
  var time = 0.obs;

  String gesturePassword = "";

  LockScreenPasswordLogic() {
    gesturePassword = SpUtil.getString("_GesturePassword_", defValue: "");
  }
}
