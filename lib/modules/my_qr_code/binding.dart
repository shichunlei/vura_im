import 'package:get/get.dart';
import 'package:im/global/keys.dart';

import 'logic.dart';

class MyQrCodeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyQrCodeLogic>(() => MyQrCodeLogic(), tag: Get.arguments[Keys.ID]);
  }
}
