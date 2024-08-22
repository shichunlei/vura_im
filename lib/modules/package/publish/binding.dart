import 'package:get/get.dart';

import 'logic.dart';

class PackagePublishBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PackagePublishLogic>(() => PackagePublishLogic());
  }
}
