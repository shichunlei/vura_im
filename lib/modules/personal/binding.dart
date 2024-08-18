import 'package:get/get.dart';

import 'logic.dart';

class PersonalBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PersonalLogic>(() => PersonalLogic());
  }
}
