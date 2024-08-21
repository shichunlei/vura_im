import 'package:get/get.dart';
import 'package:im/modules/sessions/create/logic.dart';
import 'package:im/modules/sessions/join/logic.dart';

import 'logic.dart';

class SessionsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SessionsLogic>(() => SessionsLogic());
    Get.lazyPut<MyCreateSessionsLogic>(() => MyCreateSessionsLogic());
    Get.lazyPut<MyJoinSessionsLogic>(() => MyJoinSessionsLogic());
  }
}
