import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';

class FontSizeSettingPage extends StatelessWidget {
  const FontSizeSettingPage({super.key});

  FontSizeSettingLogic get logic => Get.find<FontSizeSettingLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text("字体大小设置")), body: Column(children: []));
  }
}
