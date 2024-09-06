import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vura/base/base_logic.dart';
import 'package:vura/global/enum.dart';
import 'package:vura/global/keys.dart';
import 'package:vura/route/route_path.dart';
import 'package:vura/utils/device_utils.dart';
import 'package:vura/utils/log_utils.dart';
import 'package:vura/utils/sp_util.dart';
import 'package:vura/utils/string_util.dart';
import 'package:vura/utils/toast_util.dart';

class LockScreenLogic extends BaseLogic {
  String gesturePassword = "";
  String numberPassword = "";

  List<int> gestureData = [];

  var type = CheckPasswordType.gesturePassword.obs;

  var isToggle = false.obs;

  TextEditingController controller = TextEditingController();

  LockScreenLogic() {
    controller.addListener(update);

    gesturePassword = SpUtil.getString(Keys.GESTURE_PASSWORD, defValue: "");
    numberPassword = SpUtil.getString(Keys.NUMBER_PASSWORD, defValue: "");
    if (StringUtil.isNotEmpty(gesturePassword)) {
      gestureData = gesturePassword.split("").toList().map((item) => int.parse(item)).toList();
    }
  }

  @override
  void onInit() {
    Log.d("$gesturePassword=============================$numberPassword");
    super.onInit();
    isToggle.value = StringUtil.isNotEmpty(gesturePassword) && StringUtil.isNotEmpty(numberPassword);
    type.value =
        StringUtil.isNotEmpty(gesturePassword) ? CheckPasswordType.gesturePassword : CheckPasswordType.numberPassword;
  }

  void updateCheckType() {
    if (type.value == CheckPasswordType.gesturePassword) {
      type.value = CheckPasswordType.numberPassword;
    } else {
      type.value = CheckPasswordType.gesturePassword;
    }
  }

  void onComplete(List<int?> data) {
    String result = data.join("");

    if (result == gesturePassword) {
      Get.offAllNamed(RoutePath.HOME_PAGE);
    }
  }

  int maxCount = 6;

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
      String password = codeList.toList().join("");
      if (password == numberPassword) {
        DeviceUtils.hideKeyboard(context);
        Get.offAllNamed(RoutePath.HOME_PAGE);
      } else {
        showToast(text: "密码错误，请重试");
        codeList.value = ['', '', '', '', "", ""];
      }
    }
  }
}
