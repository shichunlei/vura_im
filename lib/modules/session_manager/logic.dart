import 'package:get/get.dart';
import 'package:im/base/base_logic.dart';
import 'package:im/global/keys.dart';

class SessionManagerLogic extends BaseLogic {
  int? id;

  SessionManagerLogic() {
    id = Get.arguments[Keys.ID];
  }
}
