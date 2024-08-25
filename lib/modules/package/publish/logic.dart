import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:im/base/base_logic.dart';
import 'package:im/entities/base_bean.dart';
import 'package:im/global/enum.dart';
import 'package:im/global/keys.dart';
import 'package:im/repository/session_repository.dart';

class PackagePublishLogic extends BaseLogic {
  var showCover = false.obs;

  String? id;
  late SessionType type;

  PackagePublishLogic() {
    id = Get.arguments[Keys.ID];
    type = Get.arguments[Keys.TYPE];
  }

  TextEditingController amountController = TextEditingController();
  TextEditingController countController = TextEditingController();
  TextEditingController textController = TextEditingController();

  Future sendRedPackage() async {
    params["receiverId"] = id;
    params["blessing"] = textController.text;
    params["cover"] = "default";
    params["totalAmount"] = amountController.text;
    params["totalPacket"] = countController.text;
    params["type"] = type == SessionType.private ? 1 : 2; // 1 单人红包 2 普通群红包 3 拼手气红包
    showLoading();
    BaseBean result = await SessionRepository.sendRedPackage(params);
    hiddenLoading();
    if (result.code == 200) {

    }
  }
}
