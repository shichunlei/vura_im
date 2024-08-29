import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';

class PayPasswordPage extends StatelessWidget {
  const PayPasswordPage({super.key});

  PayPasswordLogic get logic => Get.find<PayPasswordLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text("支付密码")), body: Column(children: []));
  }
}
