import 'package:get/get.dart';
import 'package:vura/global/keys.dart';

import 'logic.dart';

class GroupSessionDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GroupSessionDetailLogic>(() => GroupSessionDetailLogic(), tag: Get.arguments[Keys.ID]);
  }
}
