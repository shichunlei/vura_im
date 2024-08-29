import 'package:get/get.dart';

import 'logic.dart';

class ChatBackgroundBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatBackgroundLogic>(() => ChatBackgroundLogic());
  }
}
