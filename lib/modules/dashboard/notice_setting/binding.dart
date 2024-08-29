import 'package:get/get.dart';

import 'logic.dart';

class NoticeSettingBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NoticeSettingLogic>(() => NoticeSettingLogic());
  }
}
