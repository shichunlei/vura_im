import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gesture_password_widget/widget/gesture_password_widget.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vura/utils/color_util.dart';

import 'logic.dart';

class GesturePasswordPage extends StatelessWidget {
  const GesturePasswordPage({super.key});

  GesturePasswordLogic get logic => Get.find<GesturePasswordLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(),
        body: Column(children: [
          Container(
              margin: EdgeInsets.only(top: 22.h, left: 44.w),
              alignment: Alignment.centerLeft,
              child: Text("请设置6位支付密码",
                  style:
                      GoogleFonts.dmSans(color: ColorUtil.color_333333, fontWeight: FontWeight.bold, fontSize: 22.sp))),
          Container(
              margin: EdgeInsets.only(top: 13.h, left: 44.w, bottom: 35.h),
              alignment: Alignment.centerLeft,
              child: Text("请输入设置的支付密码", style: GoogleFonts.dmSans(color: ColorUtil.color_333333, fontSize: 13.sp))),
          GesturePasswordWidget(
              lineColor: const Color(0xff0C6BFE),
              errorLineColor: Colors.redAccent,
              singleLineCount: 3,
              identifySize: 60.r,
              minLength: 4,
              errorItem: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60), border: Border.all(color: Colors.redAccent, width: 1)),
                  height: 60.r,
                  width: 60.r,
                  alignment: Alignment.center,
                  child: Container(
                      height: 20.r,
                      width: 20.r,
                      decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(10)))),
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
                      decoration:
                          BoxDecoration(color: const Color(0xff0C6BFE), borderRadius: BorderRadius.circular(10)))),
              arrowItem: const Icon(Icons.arrow_right, color: Color(0xff0C6BFE)),
              errorArrowItem: const Icon(Icons.arrow_right, color: Colors.redAccent),
              answer: [0, 1, 2, 4, 7],
              color: Colors.white,
              onComplete: (data) {})
        ]));
  }
}
