import 'package:get/get.dart';

import 'logic.dart';

class LanguageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LanguageLogic>(() => LanguageLogic());
  }
}
