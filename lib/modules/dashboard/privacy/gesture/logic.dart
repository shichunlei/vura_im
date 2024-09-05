import 'package:vura/base/base_logic.dart';
import 'package:vura/utils/sp_util.dart';

class GestureLogic extends BaseLogic {
  String gesturePassword = "";

  GestureLogic() {
    gesturePassword = SpUtil.getString("_GesturePassword_", defValue: "");

    data = gesturePassword.split("").toList().map((item) => int.parse(item)).toList();
  }

  List<int> data = [];

  void onComplete(List<int?> data) {}
}
