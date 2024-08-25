import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:im/widgets/obx_widget.dart';

import 'logic.dart';

class ChargeWayPage extends StatelessWidget {
  const ChargeWayPage({super.key});

  ChargeWayLogic get logic => Get.find<ChargeWayLogic>();

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xffC5E9C2), Color(0xfffafafa), Color(0xfffafafa), Color(0xfffafafa)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter))),
      Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(title: const Text("收款方式"), backgroundColor: Colors.transparent, centerTitle: true),
          body: BaseWidget(
              logic: logic,
              builder: (logic) {
                return Container();
              }))
    ]);
  }
}
