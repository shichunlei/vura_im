import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vura/base/base_logic.dart';
import 'package:vura/entities/message_entity.dart';
import 'package:vura/global/enum.dart';
import 'package:vura/global/keys.dart';
import 'package:vura/repository/session_repository.dart';
import 'package:vura/utils/string_util.dart';
import 'package:vura/utils/toast_util.dart';

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

  List<int> mines = [1, 2];

  Future sendRedPackage() async {
    if (StringUtil.isEmpty(amountController.text)) {
      showToast(text: "请输入总金额");
      return;
    }

    if (StringUtil.isEmpty(countController.text)) {
      showToast(text: "请输入幸运值个数");
      return;
    }

    params["receiverId"] = id; // 接收人ID/群聊ID
    params["blessing"] = textController.text;
    // params["amountOne"] = ""; // 单个红包金额，单位是元，最少0.01元
    params["cover"] = "default"; // 红包封面
    if (type == SessionType.group) params['mines'] = [1, 2]; // 雷点号
    params["totalAmount"] = double.tryParse(amountController.text); // 红包总金额
    params["totalPacket"] = type == SessionType.group ? int.tryParse(countController.text) : 1; // 红包总个数
    params["type"] = type == SessionType.private
        ? 1
        : mines.isNotEmpty
            ? 3
            : 2; // 红包类型 1 单人红包 2 普通群红包 3 拼手气红包(红包雷)
    showLoading();
    MessageEntity? result = await SessionRepository.sendRedPackage(params, type);
    hiddenLoading();
    if (result != null) {
      Get.back();
    }
  }
}
