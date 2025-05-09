import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vura/base/base_logic.dart';
import 'package:vura/global/keys.dart';
import 'package:vura/modules/dashboard/privacy/lock_screen_password/logic.dart';
import 'package:vura/utils/device_utils.dart';
import 'package:vura/utils/log_utils.dart';
import 'package:vura/utils/sp_util.dart';
import 'package:vura/utils/string_util.dart';
import 'package:vura/utils/toast_util.dart';

class SetNumberPasswordLogic extends BaseLogic {
  int maxCount = 6;

  TextEditingController controller = TextEditingController();

  var password = "";
  var rePassword = "";

  var reInput = false.obs;

  SetNumberPasswordLogic() {
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
      if (StringUtil.isEmpty(password) && !reInput.value) {
        password = codeList.toList().join("");
        codeList.value = ['', '', '', '', "", ""];
        controller.text = "";
        reInput.value = true;
      } else {
        rePassword = codeList.toList().join("");

        if (password == rePassword) {
          DeviceUtils.hideKeyboard(context);
          showToast(text: "设置成功");
          SpUtil.setString(Keys.NUMBER_PASSWORD, password);
          Future.delayed(const Duration(milliseconds: 500), () {
            try {
              Get.find<LockScreenPasswordLogic>();
            } catch (e) {
              Log.e(e.toString());
            }
            Get.back();
          });
        } else {
          showToast(text: "两次密码不一致");
          codeList.value = ['', '', '', '', "", ""];
          reInput.value = false;
          controller.text = "";
        }
      }
    }
  }
}
