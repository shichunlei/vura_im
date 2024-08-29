import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';

class GesturePasswordPage extends StatelessWidget {
  const GesturePasswordPage({super.key});

  GesturePasswordLogic get logic => Get.find<GesturePasswordLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text("手势密码")), body: Column(children: []));
  }
}
