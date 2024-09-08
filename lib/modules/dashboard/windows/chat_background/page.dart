import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'logic.dart';

class ChatBackgroundPage extends StatelessWidget {
  const ChatBackgroundPage({super.key});

  ChatBackgroundLogic get logic => Get.find<ChatBackgroundLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Chat Background".tr), centerTitle: true, actions: [
          TextButton(
              onPressed: () {
                logic.selectBackground(0);
              },
              child: Text("Default".tr))
        ]),
        body: GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 22.h),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, mainAxisSpacing: 9.w, crossAxisSpacing: 9.w, childAspectRatio: 116 / 161),
            itemBuilder: (_, index) {
              return Obx(() {
                return GestureDetector(
                    onTap: () {
                      logic.selectBackground(index + 1);
                    },
                    behavior: HitTestBehavior.translucent,
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(13.r),
                            color: logic.selectedBgIndex.value == index + 1 ? Colors.red : Colors.transparent,
                            border: Border.all(
                                color: logic.selectedBgIndex.value == index + 1 ? Colors.red : Colors.transparent)),
                        padding: EdgeInsets.symmetric(horizontal: logic.selectedBgIndex.value == index + 1 ? 2.w : 0),
                        child: Image.asset("assets/images/chat_bg_${index + 1}.png")));
              });
            },
            itemCount: 12));
  }
}
