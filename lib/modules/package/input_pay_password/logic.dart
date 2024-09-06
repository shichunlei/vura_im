import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vura/base/base_logic.dart';
import 'package:vura/entities/base_bean.dart';
import 'package:vura/repository/user_repository.dart';
import 'package:vura/utils/device_utils.dart';

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

    if (value.length == maxCount) checkPayPassword(context, value);
  }

  Future checkPayPassword(BuildContext context, String password) async {
    showLoading();
    BaseBean result = await UserRepository.checkPayPassword(password);
    hiddenLoading();
    if (result.code == 200) {
      if (context.mounted) DeviceUtils.hideKeyboard(context);
      Get.back();
    } else {
      controller.clear();
      codeList.value = ['', '', '', '', "", ""];
    }
  }
}
