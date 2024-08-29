import 'package:get/get.dart';
import 'package:vura/base/base_logic.dart';
import 'package:vura/utils/device_utils.dart';

class DevicesLogic extends BaseLogic {
  var deviceName = "".obs;

  @override
  void onInit() {
    getDeviceName();
    super.onInit();
  }

  void getDeviceName() async {
    deviceName.value = await DeviceUtils.getDeviceName();
  }
}
