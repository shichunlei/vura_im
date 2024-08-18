import 'package:get/get.dart';

import 'contacts/logic.dart';
import 'logic.dart';
import 'mine/logic.dart';
import 'session/logic.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeLogic>(() => HomeLogic());
    Get.lazyPut<MineLogic>(() => MineLogic());
    Get.lazyPut<ContactsLogic>(() => ContactsLogic());
    Get.lazyPut<SessionLogic>(() => SessionLogic());
  }
}
