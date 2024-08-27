import 'package:get/get.dart';
import 'package:vura/modules/contacts/home/logic.dart';
import 'package:vura/modules/dashboard/mine/logic.dart';
import 'package:vura/modules/im/session/logic.dart';

import 'logic.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeLogic>(() => HomeLogic());
    Get.lazyPut<MineLogic>(() => MineLogic());
    Get.lazyPut<ContactsLogic>(() => ContactsLogic());
    Get.lazyPut<SessionLogic>(() => SessionLogic());
  }
}
