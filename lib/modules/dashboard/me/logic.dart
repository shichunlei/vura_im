import 'package:get/get.dart';
import 'package:vura/base/base_logic.dart';
import 'package:vura/mixin/qr_scan_mixin.dart';
import 'package:vura/modules/root/logic.dart';
import 'package:vura/utils/log_utils.dart';

class MineLogic extends BaseLogic with QrScanMixin {
  var showMoney = false.obs;

  @override
  void onInit() {
    getUserInfo();
    super.onInit();
  }

  void getUserInfo() async {
    try {
      Get.find<RootLogic>().refreshUserInfo();
    } catch (e) {
      Log.e(e.toString());
    }

    try {
      Get.find<RootLogic>().getRate();
    } catch (e) {
      Log.e(e.toString());
    }
  }
}
