import 'package:get/get.dart';
import 'package:im/global/keys.dart';

import 'logic.dart';

class ChatBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatLogic>(() => ChatLogic(), tag: "${Get.arguments[Keys.ID]}");
  }
}
