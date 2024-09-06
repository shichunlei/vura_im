import 'package:get/get.dart';
import 'package:vura/base/base_logic.dart';
import 'package:vura/global/enum.dart';
import 'package:vura/global/keys.dart';
import 'package:vura/modules/root/logic.dart';
import 'package:vura/utils/log_utils.dart';
import 'package:vura/utils/sp_util.dart';

class FontSizeSettingLogic extends BaseLogic {
  var textSizeType = TextSizeType.one.obs;

  FontSizeSettingLogic() {
    try {
      textSizeType.value = Get.find<RootLogic>().textSizeType.value;
    } catch (e) {
      Log.e(e.toString());
    }
  }

  void updateFontSize(double value) {
    textSizeType.value = TextSizeType.values.singleWhere((item) => item.stepValue == value);
  }

  void setFontSize() {
    SpUtil.setString(Keys.TEXT_SIZE, textSizeType.value.name);
    try {
      Get.find<RootLogic>().updateFontSize(textSizeType.value);
    } catch (e) {
      Log.e(e.toString());
    }
    Get.back();
  }
}
