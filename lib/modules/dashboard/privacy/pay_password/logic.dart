import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:vura/base/base_logic.dart';
import 'package:vura/entities/base_bean.dart';
import 'package:vura/modules/root/logic.dart';
import 'package:vura/repository/user_repository.dart';
import 'package:vura/utils/device_utils.dart';
import 'package:vura/utils/log_utils.dart';
import 'package:vura/utils/string_util.dart';
import 'package:vura/utils/toast_util.dart';

class PayPasswordLogic extends BaseLogic {
  int maxCount = 6;

  TextEditingController controller = TextEditingController();

  var password = "";
  var rePassword = "";

  var reInput = false.obs;

  PayPasswordLogic() {
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
          setPayPassword(rePassword);
        } else {
          showToast(text: "两次密码不一致");
          codeList.value = ['', '', '', '', "", ""];
          reInput.value = false;
          controller.text = "";
        }
      }
    }
  }

  Future setPayPassword(String password) async {
    showLoading();
    BaseBean result = await UserRepository.setPayPassword(password);
    hiddenLoading();
    if (result.code == 200) {
      showToast(text: "设置成功");
      try {
        Get.find<RootLogic>().updatePayPassword(password);
      } catch (e) {
        Log.e(e.toString());
      }
      Get.back();
    }
  }
}
