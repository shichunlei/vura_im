import 'package:get/get.dart';

import 'logic.dart';

class SearchBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchLogic>(() => SearchLogic());
  }
}
