import 'package:get/get.dart';
import 'package:vura/base/base_logic.dart';
import 'package:vura/route/route_path.dart';
import 'package:vura/utils/sp_util.dart';

class GestureLogic extends BaseLogic {
  String gesturePassword = "";

  List<int> data = [];

  GestureLogic() {
    gesturePassword = SpUtil.getString("_GesturePassword_", defValue: "");
    data = gesturePassword.split("").toList().map((item) => int.parse(item)).toList();
  }

  void onComplete(List<int?> data) {
    String result = data.join("");

    if (result == gesturePassword) {
      Get.offAllNamed(RoutePath.HOME_PAGE);
    }
  }
}
