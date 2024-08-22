import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:im/widgets/obx_widget.dart';

import 'logic.dart';

class PackageResultPage extends StatelessWidget {
  final String? tag;

  const PackageResultPage({super.key, this.tag});

  PackageResultLogic get logic => Get.find<PackageResultLogic>(tag: tag);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("发幸运值"), centerTitle: true),
        body: BaseWidget(
            logic: logic,
            builder: (logic) {
              return Column(children: []);
            }));
  }
}
