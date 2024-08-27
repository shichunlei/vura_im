import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vura/base/base_logic.dart';

class SessionsLogic extends BaseLogic with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  SessionsLogic() {
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
