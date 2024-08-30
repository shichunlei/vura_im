import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vura/widgets/obx_widget.dart';

import 'logic.dart';

class PhoneContactsPage extends StatelessWidget {
  const PhoneContactsPage({super.key});

  PhoneContactsLogic get logic => Get.find<PhoneContactsLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("联系人")),
        body: BaseWidget(
            logic: logic,
            builder: (logic) {
              return ListView.separated(
                  itemBuilder: (_, index) {
                    return Container();
                  },
                  separatorBuilder: (_, index) => const Divider(height: 0),
                  itemCount: logic.list.length);
            }));
  }
}
