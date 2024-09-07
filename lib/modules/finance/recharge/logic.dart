import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vura/base/base_list_logic.dart';
import 'package:vura/entities/base_bean.dart';
import 'package:vura/entities/withdraw_entity.dart';
import 'package:vura/modules/root/logic.dart';
import 'package:vura/repository/common_repository.dart';
import 'package:vura/utils/toast_util.dart';

class RechargeLogic extends BaseListLogic<WithdrawEntity> {
  TextEditingController controller = TextEditingController();

  RechargeLogic() {
    controller.addListener(() {
      if (list.every((item) => item.usdt != num.parse(controller.text))) {
        selectIndex.value = -1;
      } else {
        selectIndex.value = list.indexWhere((item) => item.usdt == num.parse(controller.text));
      }
      update();
    });
  }

  @override
  void onInit() {
    initData();
    super.onInit();
  }

  var selectIndex = 0.obs;

  @override
  Future<List<WithdrawEntity>> loadData() async {
    return WithdrawEntity.getWithdraw(Get.find<RootLogic>().exchangeRate.value);
  }

  @override
  void onCompleted(List<WithdrawEntity> data) {
    if (data.isNotEmpty) controller.text = "${data[selectIndex.value].usdt}";
  }

  Future recharge() async {
    showLoading();
    BaseBean result = await CommonRepository.withdraw(
        type: 2,
        money: double.parse(controller.text),
        account: Get.find<RootLogic>().user.value?.walletCard,
        remarks: "充值");
    hiddenLoading();
    if (result.code == 200) {
      showToast(text: "充值申请已提交");
    }
  }
}
