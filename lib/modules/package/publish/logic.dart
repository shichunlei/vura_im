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
    params["receiverId"] = id; // 接收人ID/群聊ID
    params["blessing"] = textController.text;
    // params["amountOne"] = ""; // 单个红包金额，单位是元，最少0.01元
    params["cover"] = "default"; // 红包封面
    if (type == SessionType.group) params['mines'] = []; // 雷点号
    params["totalAmount"] = amountController.text; // 红包总金额
    params["totalPacket"] = type == SessionType.group ? countController.text : 1; // 红包总个数
    params["type"] = type == SessionType.private ? 1 : 2; // 红包类型 1 单人红包 2 普通群红包 3 拼手气红包(红包雷)
    showLoading();
    BaseBean result = await SessionRepository.sendRedPackage(params, type);
    hiddenLoading();
    if (result.code == 200) {}
  }
}
