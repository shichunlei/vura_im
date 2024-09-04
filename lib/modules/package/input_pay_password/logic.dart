import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vura/base/base_logic.dart';

class InputPayPasswordLogic extends BaseLogic {
  int maxCount = 6;

  TextEditingController controller = TextEditingController();

  InputPayPasswordLogic() {
    controller.addListener(update);
  }

  RxList<String> codeList = RxList<String>(['', '', '', '', "", ""]);

  void textChange(BuildContext context, String value) {
    List.generate(maxCount, (index) {
      if (value.length > index) {
        codeList[index] = value[index];
      } else {
        codeList[index] = '';
      }
    });
    codeList.refresh();

    if (value.length == maxCount) {
      Get.back(result: value);
    }
  }
}
