import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:vura/base/base_object_logic.dart';
import 'package:vura/entities/base_bean.dart';
import 'package:vura/entities/user_entity.dart';
import 'package:vura/global/enum.dart';
import 'package:vura/modules/root/logic.dart';
import 'package:vura/repository/common_repository.dart';
import 'package:vura/repository/user_repository.dart';
import 'package:vura/utils/log_utils.dart';
import 'package:vura/utils/toast_util.dart';

class TransferLogic extends BaseObjectLogic<UserEntity?> {
  TextEditingController addressController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  var user = Rx<UserEntity?>(null);

  TransferLogic() {
    addressController.addListener(update);
    amountController.addListener(update);
  }

  @override
  void onInit() {
    initData();
    super.onInit();
  }

  @override
  Future<UserEntity?> loadData() async {
    return await UserRepository.getUserInfo();
  }

  @override
  void onCompleted(UserEntity? data) {
    if (data != null) {
      try {
        Get.find<RootLogic>().setUserInfo(data);
      } catch (e) {
        Log.e(e.toString());
      }
    }
  }

  var previousText = ''.obs;

  void onTextChanged(String currentText) {
    // 检查是否是删除操作
    if (previousText.value.length > currentText.length) {
      // 如果当前文本包含小数点，并且小数点在最后
      if (currentText.contains('.') && currentText.endsWith('.')) {
        // 如果小数点后面没有数字了，则删除小数点
        amountController.text = currentText.substring(0, currentText.length - 1);
        // 调整光标位置
        amountController.selection = TextSelection.fromPosition(
          TextPosition(offset: amountController.text.length),
        );
      }
    }

    // 更新 previousText 为当前文本
    previousText.value = amountController.text;
  }

  Future transfer(String password) async {
    showLoading();
    BaseBean result = await CommonRepository.withdraw(
        type: BookType.TRANSFER,
        money: double.parse(amountController.text),
        account: addressController.text,
        remarks: "转账",
        payPassword: password);
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

  Future transferToMember(String password) async {
    showLoading();
    BaseBean result = await CommonRepository.transferToMember(
        userId: user.value?.id, money: double.parse(amountController.text), remarks: "转账", payPassword: password);
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

  void selectUser(UserEntity user) {
    this.user.value = user;
  }
}
