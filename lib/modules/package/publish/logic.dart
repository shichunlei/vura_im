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

    amountController.addListener(update);
  }

  TextEditingController amountController = TextEditingController();
  TextEditingController countController = TextEditingController();
  TextEditingController textController = TextEditingController();
  TextEditingController valueController = TextEditingController();

  List<int?> mines = [];

  Future sendRedPackage() async {
    if (StringUtil.isEmpty(amountController.text)) {
      showToast(text: "请输入总金额");
      return;
    }

    if (type == SessionType.group && StringUtil.isEmpty(countController.text)) {
      showToast(text: "请输入幸运值个数");
      return;
    }

    if (type == SessionType.group && StringUtil.isNotEmpty(valueController.text)) {
      mines = List.generate(valueController.text.length, (int index) {
        return int.tryParse(valueController.text[index]);
      }).toList();
    }

    params["receiverId"] = id; // 接收人ID/群聊ID
    params["blessing"] = StringUtil.isEmpty(textController.text) ? "恭喜发财，大吉大利" : textController.text;
    // params["amountOne"] = ""; // 单个红包金额，单位是元，最少0.01元
    params["cover"] = "default"; // todo 红包封面
    if (type == SessionType.group) params['mines'] = mines; // 雷点号
    params["totalAmount"] = StringUtil.isEmpty(amountController.text)
        ? 0.00
        : double.tryParse(double.parse(amountController.text).toStringAsFixed(2)); // 红包总金额
    params["totalPacket"] = type == SessionType.group ? int.tryParse(countController.text) : 1; // 红包总个数
    params["type"] = type == SessionType.private
        ? 1
        : mines.isNotEmpty
            ? 3
            : 2; // 红包类型 1 单人红包 2 普通群红包 3 拼手气红包(红包雷)
    showLoading();
    MessageEntity? message = await SessionRepository.sendRedPackage(params, type);
    hiddenLoading();
    if (message != null) {
      showToast(text: "已发送");
      Get.back(result: message);
    }
  }
}
