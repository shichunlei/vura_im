import 'package:get/get.dart';
import 'package:vura/base/base_logic.dart';
import 'package:vura/utils/sp_util.dart';

class GesturePasswordLogic extends BaseLogic {
  var isFirst = true.obs;

  String firstData = "";

  var tip = "绘制解锁图案，至少链接4个点".obs;

  void onComplete(List<int?> data) {
    if (isFirst.value) {
      if (data.length < 4) {
        tip.value = "请重新绘制";
        return;
      }
      tip.value = "已记录图案";
      Future.delayed(const Duration(seconds: 1), () {
        isFirst.value = false;
        firstData = data.join("");
        tip.value = "再次绘制图案进行确认";
      });
    } else {
      String secondData = data.join("");
      if (firstData == secondData) {
        // 设置成功
        tip.value = "已完成绘制";
        Future.delayed(const Duration(seconds: 1), () {
          SpUtil.setString("_GesturePassword_", firstData);
          Get.back();
        });
      } else {
        tip.value = "两次图案不一致，请重新设置";
        Future.delayed(const Duration(seconds: 1), () {
          // 两次不一致，重新设置
          isFirst.value = true;
          tip.value = "绘制解锁图案，至少链接4个点";
        });
      }
    }
  }
}
