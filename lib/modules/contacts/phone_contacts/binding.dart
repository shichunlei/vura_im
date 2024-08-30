import 'package:get/get.dart';

import 'logic.dart';

class PhoneContactsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PhoneContactsLogic>(() => PhoneContactsLogic());
  }
}
