import 'package:get/get.dart';
import 'package:vura/base/base_logic.dart';
import 'package:vura/global/keys.dart';
import 'package:vura/utils/sp_util.dart';

class ChatBackgroundLogic extends BaseLogic {
  var selectedBgIndex = 0.obs;

  ChatBackgroundLogic() {
    selectedBgIndex.value = SpUtil.getInt(Keys.CHAT_BG_IMAGE_INDEX, defValue: 0);
  }

  void selectBackground(int index) {
    selectedBgIndex.value = index;
    SpUtil.setInt(Keys.CHAT_BG_IMAGE_INDEX, index);
  }
}
