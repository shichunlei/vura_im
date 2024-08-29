import 'package:get/get.dart';

import 'logic.dart';

class FontSizeSettingBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FontSizeSettingLogic>(() => FontSizeSettingLogic());
  }
}
