import 'package:get/get.dart';
import 'package:vura/global/keys.dart';

import 'logic.dart';

class PackageResultBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PackageResultLogic>(() => PackageResultLogic(), tag: Get.arguments[Keys.ID]);
  }
}
