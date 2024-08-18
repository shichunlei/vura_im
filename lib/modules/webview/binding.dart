import 'package:get/get.dart';

import 'logic.dart';

class WebViewBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WebViewLogic>(() => WebViewLogic());
  }
}
