import 'package:get/get.dart';
import 'package:vura/modules/contacts/home/logic.dart';
import 'package:vura/modules/dashboard/me/logic.dart';
import 'package:vura/modules/im/session/logic.dart';

import 'logic.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeLogic>(() => HomeLogic());
    Get.lazyPut<MineLogic>(() => MineLogic());
    Get.lazyPut<SessionLogic>(() => SessionLogic());

    /// 提前注册联系人的Logic
    Get.put(ContactsLogic());
  }
}
