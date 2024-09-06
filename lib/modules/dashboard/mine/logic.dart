import 'package:get/get.dart';
import 'package:vura/base/base_logic.dart';
import 'package:vura/mixin/qr_scan_mixin.dart';

class MineLogic extends BaseLogic with QrScanMixin {
  var showMoney = false.obs;
}
