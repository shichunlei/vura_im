import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vura/route/route_path.dart';
import 'package:vura/utils/color_util.dart';
import 'package:vura/widgets/radius_inkwell_widget.dart';

import 'logic.dart';

class LockScreenPasswordPage extends StatelessWidget {
  const LockScreenPasswordPage({super.key});

  LockScreenPasswordLogic get logic => Get.find<LockScreenPasswordLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("锁屏密码")),
        body: Column(children: [
          Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(11.r), color: Colors.white),
              margin: EdgeInsets.only(left: 22.w, top: 22.h, right: 22.w),
              child: Column(children: [
                RadiusInkWellWidget(
                    color: Colors.transparent,
                    onPressed: () {
                      Get.toNamed(RoutePath.GESTURE_PASSWORD_PAGE);
                    },
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(11.r), topRight: Radius.circular(11.r)),
                    child: Container(
                        height: 60.h,
                        padding: EdgeInsets.only(left: 22.w, right: 10.w),
                        child: Row(children: [
                          Text("锁屏手势", style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_333333)),
                          const Spacer(),
                          const Icon(Icons.keyboard_arrow_right, color: ColorUtil.color_999999)
                        ]))),
                Divider(height: 0, indent: 22.w, endIndent: 22.w),
                RadiusInkWellWidget(
                    color: Colors.transparent,
                    borderRadius:
                        BorderRadius.only(bottomLeft: Radius.circular(11.r), bottomRight: Radius.circular(11.r)),
                    onPressed: () {},
                    child: Container(
                        height: 60.h,
                        padding: EdgeInsets.only(left: 22.w, right: 10.w),
                        child: Row(children: [
                          Text("锁屏密码", style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_333333)),
                          const Spacer(),
                          const Icon(Icons.keyboard_arrow_right, color: ColorUtil.color_999999)
                        ])))
              ])),
          Container(
              height: 60.h,
              padding: EdgeInsets.only(left: 22.w, right: 10.w),
              alignment: Alignment.centerLeft,
              child: Text("设置锁屏密码/锁屏手势后所有设备上都有效通用",
                  style: GoogleFonts.roboto(fontSize: 13.sp, color: ColorUtil.color_999999))),
          RadiusInkWellWidget(
              margin: EdgeInsets.symmetric(horizontal: 22.w),
              color: Colors.white,
              borderRadius: BorderRadius.circular(11.r),
              onPressed: () {},
              child: Container(
                  height: 60.h,
                  padding: EdgeInsets.only(left: 22.w, right: 10.w),
                  child: Row(children: [
                    Text("锁屏时间", style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_333333)),
                    const Spacer(),
                    const Icon(Icons.keyboard_arrow_right, color: ColorUtil.color_999999)
                  ]))),
          Container(
              height: 60.h,
              padding: EdgeInsets.only(left: 22.w, right: 10.w),
              alignment: Alignment.centerLeft,
              child: Text("应用挂在后台一段时间不操作后会进入锁屏状态",
                  style: GoogleFonts.roboto(fontSize: 13.sp, color: ColorUtil.color_999999)))
        ]));
  }
}
