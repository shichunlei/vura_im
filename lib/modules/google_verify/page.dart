import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:im/widgets/obx_widget.dart';

import 'logic.dart';

class GoogleVerifyPage extends StatelessWidget {
  const GoogleVerifyPage({super.key});

  GoogleVerifyLogic get logic => Get.find<GoogleVerifyLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("谷歌验证绑定"), centerTitle: true),
        body: BaseWidget(
            logic: logic,
            builder: (logic) {
              return Column(children: []);
            }));
  }
}
