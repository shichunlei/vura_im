import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gesture_password_widget/widget/gesture_password_widget.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vura/utils/color_util.dart';

import 'logic.dart';

class GesturePage extends StatelessWidget {
  const GesturePage({super.key});

  GestureLogic get logic => Get.find<GestureLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(),
        body: Column(children: [
          Container(
              alignment: Alignment.center,
              child: Text("手势密码",
                  style:
                      GoogleFonts.dmSans(color: ColorUtil.color_333333, fontWeight: FontWeight.bold, fontSize: 22.sp))),
          Expanded(
              child: Container(
                  padding: EdgeInsets.only(top: 50.h),
                  alignment: Alignment.topCenter,
                  child: GesturePasswordWidget(
                      loose: false,
                      lineColor: const Color(0xff0C6BFE),
                      errorLineColor: Colors.redAccent,
                      singleLineCount: 3,
                      identifySize: 60.r,
                      minLength: 4,
                      errorItem: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(60),
                              border: Border.all(color: Colors.redAccent, width: 1)),
                          height: 60.r,
                          width: 60.r,
                          alignment: Alignment.center,
                          child: Container(
                              height: 20.r,
                              width: 20.r,
                              decoration:
                                  BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(10)))),
                      normalItem: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(60),
                              border: Border.all(color: const Color(0xffdddddd), width: 1)),
                          height: 60.r,
                          width: 60.r),
                      selectedItem: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(60),
                              border: Border.all(color: const Color(0xffdddddd), width: 1)),
                          height: 60.r,
                          width: 60.r,
                          alignment: Alignment.center,
                          child: Container(
                              height: 20.r,
                              width: 20.r,
                              decoration: BoxDecoration(
                                  color: const Color(0xff0C6BFE), borderRadius: BorderRadius.circular(10)))),
                      arrowItem: const Icon(Icons.arrow_right, color: Color(0xff0C6BFE)),
                      errorArrowItem: const Icon(Icons.arrow_right, color: Colors.redAccent),
                      color: Colors.white,
                      completeWaitMilliseconds: 1000,
                      onComplete: logic.onComplete,
                      answer: logic.data)))
        ]));
  }
}
