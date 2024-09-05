import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vura/base/base_logic.dart';
import 'package:vura/modules/im/emoji/sub/logic.dart';

class EmojiHomeLogic extends BaseLogic with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  EmojiHomeLogic() {
    tabController = TabController(length: 3, vsync: this);

    Get.lazyPut<EmojiLogic>(() => EmojiLogic("normal"), tag: "normal");
    Get.lazyPut<EmojiLogic>(() => EmojiLogic("duck"), tag: "duck");
    Get.lazyPut<EmojiLogic>(() => EmojiLogic("fish"), tag: "fish");
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
