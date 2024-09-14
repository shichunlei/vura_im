import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vura/base/base_list_logic.dart';
import 'package:vura/entities/base_bean.dart';
import 'package:vura/entities/rate_entity.dart';
import 'package:vura/entities/withdraw_entity.dart';
import 'package:vura/global/enum.dart';
import 'package:vura/modules/finance/wallet/logic.dart';
import 'package:vura/modules/root/logic.dart';
import 'package:vura/repository/common_repository.dart';
import 'package:vura/utils/log_utils.dart';
import 'package:vura/utils/toast_util.dart';

class WithdrawLogic extends BaseListLogic<WithdrawEntity> {
  TextEditingController controller = TextEditingController();

  var fee = .0.obs;
  var exchangeRate = .0.obs;

  WithdrawLogic() {
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
    getFee();
    super.onInit();
  }

  var selectIndex = 0.obs;

  @override
  Future<List<WithdrawEntity>> loadData() async {
    await getRate();
    return WithdrawEntity.getWithdraw(exchangeRate.value);
  }

  @override
  void onCompleted(List<WithdrawEntity> data) {
    if (data.isNotEmpty) controller.text = "${data[selectIndex.value].usdt}";
  }

  /// 获取汇率
  Future getFee() async {
    RateEntity? result = await CommonRepository.getFee();
    if (result != null) {
      fee.value = result.value ?? 0;
    } else {
      fee.value = 0;
    }
  }

  /// 获取汇率
  Future getRate() async {
    RateEntity? result = await CommonRepository.getRate();
    if (result != null) {
      exchangeRate.value = result.value ?? 7.15;
    } else {
      exchangeRate.value = 7.15;
    }
  }

  Future withdraw(String password) async {
    showLoading();
    BaseBean result = await CommonRepository.withdraw(
        type: BookType.WIDTH_DRAW,
        money: double.parse(controller.text),
        account: Get.find<RootLogic>().user.value?.walletCard,
        remarks: "提现",
        payPassword: password);
    hiddenLoading();
    if (result.code == 200) {
      showToast(text: "提现申请已提交");
      try {
        Get.find<RootLogic>().refreshUserInfo();
      } catch (e) {
        Log.e(e.toString());
      }
      try {
        Get.find<WalletLogic>().refreshData();
      } catch (e) {
        Log.e(e.toString());
      }
      Get.back();
    }
  }
}
