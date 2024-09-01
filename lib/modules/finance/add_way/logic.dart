import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:vura/base/base_logic.dart';
import 'package:vura/entities/base_bean.dart';
import 'package:vura/entities/receiving_payment_entity.dart';
import 'package:vura/global/keys.dart';
import 'package:vura/modules/finance/charge_way/logic.dart';
import 'package:vura/modules/root/logic.dart';
import 'package:vura/repository/user_repository.dart';
import 'package:vura/utils/log_utils.dart';
import 'package:vura/utils/string_util.dart';
import 'package:vura/utils/toast_util.dart';

class AddWayLogic extends BaseLogic {
  TextEditingController accountController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  ReceivingPaymentEntity? data;

  AddWayLogic() {
    data = Get.arguments?[Keys.DATA];

    accountController.addListener(update);
    addressController.addListener(update);

    if (data != null) {
      accountController.text = data!.walletRemark ?? "";
      addressController.text = data!.walletCard ?? "";
    }
  }

  Future addWay() async {
    if (StringUtil.isEmpty(accountController.text)) {
      showToast(text: "请输入账号备注");
      return;
    }

    if (StringUtil.isEmpty(addressController.text)) {
      showToast(text: "请输入收款地址");
      return;
    }

    showLoading();
    BaseBean result = await UserRepository.updateWallet(addressController.text, accountController.text);
    hiddenLoading();

    if (result.code == 200) {
      try {
        Get.find<ChargeWayLogic>().updateWay(
            ReceivingPaymentEntity(walletCard: addressController.text, walletRemark: accountController.text));
        Get.find<RootLogic>().updateWallet(addressController.text, accountController.text);
      } catch (e) {
        Log.e(e.toString());
      }
      Get.back();
    }
  }
}
