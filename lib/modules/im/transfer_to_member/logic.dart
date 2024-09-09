import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vura/base/base_logic.dart';
import 'package:vura/entities/base_bean.dart';
import 'package:vura/entities/user_entity.dart';
import 'package:vura/modules/root/logic.dart';
import 'package:vura/repository/common_repository.dart';
import 'package:vura/utils/log_utils.dart';
import 'package:vura/utils/toast_util.dart';

class TransferToMemberLogic extends BaseLogic {
  UserEntity? user;

  TransferToMemberLogic() {
    user = Get.arguments["user"];

    amountController.addListener(update);
  }

  TextEditingController amountController = TextEditingController();
  TextEditingController textController = TextEditingController();

  var previousText = ''.obs;

  void onTextChanged(String currentText) {
    // 检查是否是删除操作
    if (previousText.value.length > currentText.length) {
      // 如果当前文本包含小数点，并且小数点在最后
      if (currentText.contains('.') && currentText.endsWith('.')) {
        // 如果小数点后面没有数字了，则删除小数点
        amountController.text = currentText.substring(0, currentText.length - 1);
        // 调整光标位置
        amountController.selection = TextSelection.fromPosition(TextPosition(offset: amountController.text.length));
      }
    }

    // 更新 previousText 为当前文本
    previousText.value = amountController.text;
  }

  Future sendRedPackage() async {
    showLoading();
    BaseBean result = await CommonRepository.transferToMember(
        userId: user?.id, money: double.parse(amountController.text), remarks: "转账");
    hiddenLoading();
    if (result.code == 200) {
      showToast(text: "转账成功");
      try {
        Get.find<RootLogic>().refreshUserInfo();
      } catch (e) {
        Log.e(e.toString());
      }
      Get.back();
    }
  }
}
