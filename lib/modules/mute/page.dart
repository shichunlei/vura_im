import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:im/widgets/obx_widget.dart';

import 'logic.dart';

class MutePage extends StatelessWidget {
  final String? tag;

  const MutePage({super.key, this.tag});

  MuteLogic get logic => Get.find<MuteLogic>(tag: tag);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("禁言列表"), centerTitle: true),
        body: BaseWidget(
            logic: logic,
            builder: (logic) {
              return Column(children: []);
            }));
  }
}
