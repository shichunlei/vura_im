import 'package:get/get.dart';

import 'logic.dart';

class NewFriendBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewFriendLogic>(() => NewFriendLogic());
  }
}
