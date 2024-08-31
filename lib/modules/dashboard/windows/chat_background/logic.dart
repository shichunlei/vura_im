import 'package:get/get.dart';
import 'package:vura/base/base_logic.dart';
import 'package:vura/utils/sp_util.dart';

class ChatBackgroundLogic extends BaseLogic {
  var selectedBgIndex = 0.obs;

  ChatBackgroundLogic() {
    selectedBgIndex.value = SpUtil.getInt("_chat_bg_image_index_", defValue: 0);
  }

  void selectBackground(int index) {
    selectedBgIndex.value = index;
    SpUtil.setInt("_chat_bg_image_index_", index);
  }
}
