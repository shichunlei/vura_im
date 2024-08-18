import 'package:get/get.dart';

import 'logic.dart';

class SettingBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingLogic>(() => SettingLogic());
  }
}
