import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vura/base/base_logic.dart';
import 'package:vura/entities/message_entity.dart';
import 'package:vura/entities/red_package.dart';
import 'package:vura/entities/user_entity.dart';
import 'package:vura/global/enum.dart';
import 'package:vura/global/keys.dart';
import 'package:vura/modules/root/logic.dart';
import 'package:vura/repository/session_repository.dart';
import 'package:vura/utils/log_utils.dart';
import 'package:vura/utils/string_util.dart';
import 'package:vura/utils/toast_util.dart';

class PackagePublishLogic extends BaseLogic {
  var showCover = false.obs;

  String? id;
  late SessionType type;
  bool isTransfer = false;
  UserEntity? user;

  PackagePublishLogic() {
    id = Get.arguments[Keys.ID];
    type = Get.arguments[Keys.TYPE];
    isTransfer = Get.arguments?["isTransfer"] ?? false;
    user = Get.arguments?["user"];

    amountController.addListener(update);

    packageCovers = RedPackageCoverType.values.map((item) => PackageCoverEntity(item.name, item.coverPath)).toList();
    packageCovers2.value = packageCovers.where((item) => item.id != selectCover.value.id).toList();
  }

  var selectCover = PackageCoverEntity(RedPackageCoverType.cover_0.name, RedPackageCoverType.cover_0.coverPath).obs;

  RxList<PackageCoverEntity> packageCovers2 = RxList<PackageCoverEntity>([]);
  late List<PackageCoverEntity> packageCovers;

  void selectCoverFun(PackageCoverEntity cover) {
    selectCover.value = cover;
    packageCovers2.value = packageCovers.where((item) => item.id != selectCover.value.id).toList();
  }

  TextEditingController amountController = TextEditingController();
  TextEditingController countController = TextEditingController();
  TextEditingController textController = TextEditingController();
  TextEditingController valueController = TextEditingController();

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

  void validateInput(String text) {
    String _text = text.replaceAll(',', ''); // 移除已有的逗号
    if (_text.isNotEmpty) {
      // 分割输入的数字
      List<String> numbers = _text.split('').where((s) => s.isNotEmpty).toList();
      // 移除重复数字
      List<String> uniqueNumbers = numbers.toSet().toList();
      // 重新组合为字符串，保留逗号分隔符
      String newText = uniqueNumbers.join(',');
      // 如果内容有变化，更新输入框内容并调整光标位置
      if (newText != text) {
        valueController.value =
            TextEditingValue(text: newText, selection: TextSelection.collapsed(offset: newText.length));
      }
    }
  }

  List<int?> mines = [];

  Future sendRedPackage() async {
    if (type == SessionType.group && StringUtil.isNotEmpty(valueController.text)) {
      mines = valueController.text.split(",").map((e) => int.tryParse(e)).toList();
    }

    params["receiverId"] = id; // 接收人ID/群聊ID
    params["blessing"] = StringUtil.isEmpty(textController.text) ? "恭喜发财，大吉大利" : textController.text;
    params["cover"] = selectCover.value.id; // todo 红包封面
    if (type == SessionType.group) params['mines'] = mines; // 雷点号
    params["totalAmount"] = StringUtil.isEmpty(amountController.text)
        ? 0.00
        : double.tryParse(double.parse(amountController.text).toStringAsFixed(2)); // 红包总金额
    params["totalPacket"] = type == SessionType.group ? int.tryParse(countController.text) : 1; // 红包总个数
    params["type"] = type == SessionType.private
        ? isTransfer
            ? RedPackageType.SPECIAL.code
            : RedPackageType.ONE.code
        : mines.isNotEmpty
            ? RedPackageType.LUCKY.code
            : RedPackageType.ORDINARY.code; // 红包类型
    Log.json(params);

    showLoading();
    MessageEntity? message = isTransfer
        ? await SessionRepository.sendTransfer(params)
        : await SessionRepository.sendRedPackage(params, type);
    hiddenLoading();
    if (message != null) {
      try {
        Get.find<RootLogic>().refreshUserInfo();
      } catch (e) {
        Log.e(e.toString());
      }
      showToast(text: "已发送");
      Get.back(result: message);
    }
  }
}
