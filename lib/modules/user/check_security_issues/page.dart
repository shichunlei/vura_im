import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vura/utils/color_util.dart';
import 'package:vura/utils/device_utils.dart';
import 'package:vura/widgets/widgets.dart';

import 'logic.dart';

class CheckSecurityIssuesPage extends StatelessWidget {
  const CheckSecurityIssuesPage({super.key});

  CheckSecurityIssuesLogic get logic => Get.find<CheckSecurityIssuesLogic>();

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
          resizeToAvoidBottomInset: false,
          body: Hero(tag: "bg", child: Image.asset("assets/images/register_bg.webp", fit: BoxFit.cover))),
      Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 22.w),
              child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                SizedBox(height: 135.h),
                Hero(
                    tag: "hello",
                    child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text("HELLO,\n密保校验",
                            style: GoogleFonts.roboto(
                                decoration: TextDecoration.none,
                                fontSize: 26.sp,
                                fontWeight: FontWeight.bold,
                                color: ColorUtil.color_333333),
                            textAlign: TextAlign.start))),
                SizedBox(height: 22.h),
                Container(
                    alignment: Alignment.centerLeft,
                    child: Text("密保问题：您的初恋是谁？",
                        style: GoogleFonts.roboto(
                            fontSize: 13.sp, fontWeight: FontWeight.w500, color: ColorUtil.color_333333))),
                Container(
                    margin: EdgeInsets.only(top: 13.h, bottom: 22.h),
                    height: 50.h,
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9.r), border: Border.all(color: const Color(0xffe5e5e5))),
                    child: TextField(
                        controller: logic.securityIssuesController,
                        maxLines: 1,
                        style: GoogleFonts.roboto(fontSize: 13.sp, color: ColorUtil.color_333333),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 18.w),
                            hintText: "请输入密保答案",
                            hintStyle: GoogleFonts.roboto(fontSize: 13.sp, color: ColorUtil.color_999999)))),
                Hero(
                    tag: "submit_button",
                    child: RadiusInkWellWidget(
                        onPressed: () => logic.check(context),
                        radius: 44,
                        margin: EdgeInsets.only(top: 47.h),
                        child: Container(
                            width: 180.w,
                            height: 44.h,
                            alignment: Alignment.center,
                            child: Text("登录",
                                style: GoogleFonts.roboto(
                                    color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18.sp)))))
              ]))),
      Positioned(top: DeviceUtils.topSafeHeight, left: 0, child: const BackButton())
    ]);
  }
}
