import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:im/widgets/obx_widget.dart';

import 'logic.dart';

class UserInfoPage extends StatelessWidget {
  final String? tag;

  const UserInfoPage({super.key, this.tag});

  UserInfoLogic get logic => Get.find<UserInfoLogic>(tag: tag);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("用户信息"), centerTitle: true),
        body: BaseWidget(
            logic: logic,
            builder: (logic) {
              return Column(children: []);
            }));
  }
}
