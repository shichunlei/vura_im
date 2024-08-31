import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:vura/base/base_logic.dart';
import 'package:vura/utils/device_utils.dart';

class PayPasswordLogic extends BaseLogic {
  int maxCount=6;

  TextEditingController controller = TextEditingController();

  PayPasswordLogic() {
    controller.addListener(update);
  }

  RxList<String> codeList = RxList<String>(['', '', '', '', "", ""]);

  void textChange(context, String value) {
    List.generate(maxCount, (index) {
      if (value.length > index) {
        codeList[index] = value[index];
      } else {
        codeList[index] = '';
      }
    });
    codeList.refresh();

    if (value.length == maxCount) {
      DeviceUtils.hideKeyboard();
    }
  }
}
