import 'package:get/get.dart';

import 'logic.dart';

class WalletBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WalletLogic>(() => WalletLogic());
  }
}
