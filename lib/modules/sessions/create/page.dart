import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:im/modules/sessions/widgets/item_session.dart';
import 'package:im/widgets/obx_widget.dart';

import 'logic.dart';

class MyCreateSessionsPage extends StatelessWidget {
  const MyCreateSessionsPage({super.key});

  MyCreateSessionsLogic get logic => Get.find<MyCreateSessionsLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BaseWidget(
            logic: logic,
            builder: (logic) {
              return ListView.separated(
                  itemBuilder: (_, index) {
                    return ItemSession(session: logic.list[index]);
                  },
                  itemCount: logic.list.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(height: 0, indent: 18.w, endIndent: 18.w));
            }));
  }
}
