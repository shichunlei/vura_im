import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:realm/realm.dart';
import 'package:vura/base/base_logic.dart';
import 'package:vura/entities/receiving_payment_entity.dart';
import 'package:vura/global/keys.dart';
import 'package:vura/modules/finance/charge_way/logic.dart';
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
      accountController.text = data!.remark ?? "";
      addressController.text = data!.address ?? "";
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

    hiddenLoading();
    ReceivingPaymentEntity bean = ReceivingPaymentEntity(
        id: data != null ? "${data!.id}" : "${Uuid.v1()}",
        address: addressController.text,
        remark: accountController.text);
    try {
      Get.find<ChargeWayLogic>().updateWay(bean);
    } catch (e) {
      Log.e(e.toString());
    }

    Get.back();
  }
}
