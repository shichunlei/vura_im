import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vura/route/route_path.dart';
import 'package:vura/utils/color_util.dart';
import 'package:vura/utils/device_utils.dart';
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
              onPressed: () {
                Get.bottomSheet(const LockScreenTimeDialog(),
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.only(topLeft: Radius.circular(15.r), topRight: Radius.circular(15.r))))
                    .then((value) {
                  if (value != null) logic.time.value = value;
                });
              },
              child: Container(
                  height: 60.h,
                  padding: EdgeInsets.only(left: 22.w, right: 10.w),
                  child: Row(children: [
                    Text("锁屏时间", style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_333333)),
                    const Spacer(),
                    Obx(() {
                      return Text(logic.time.value == 0 ? "" : "${logic.time.value}分钟");
                    }),
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

class LockScreenTimeDialog extends StatelessWidget {
  const LockScreenTimeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          RadiusInkWellWidget(
              onPressed: () {
                Get.back(result: 1);
              },
              borderRadius: BorderRadius.only(topRight: Radius.circular(15.r), topLeft: Radius.circular(15.r)),
              color: Colors.transparent,
              child: Container(
                  height: 60.h,
                  alignment: Alignment.center,
                  child: Text("1分钟", style: GoogleFonts.roboto(color: ColorUtil.color_333333, fontSize: 18.sp)))),
          Divider(height: 0, indent: 22.w, endIndent: 22.w),
          RadiusInkWellWidget(
              onPressed: () {
                Get.back(result: 3);
              },
              radius: 0,
              color: Colors.transparent,
              child: Container(
                  height: 60.h,
                  alignment: Alignment.center,
                  child: Text("3分钟", style: GoogleFonts.roboto(color: ColorUtil.color_333333, fontSize: 18.sp)))),
          Divider(height: 0, indent: 22.w, endIndent: 22.w),
          RadiusInkWellWidget(
              onPressed: () {
                Get.back(result: 5);
              },
              radius: 0,
              color: Colors.transparent,
              child: Container(
                  height: 60.h,
                  alignment: Alignment.center,
                  child: Text("5分钟", style: GoogleFonts.roboto(color: ColorUtil.color_333333, fontSize: 18.sp)))),
          Divider(height: 0, indent: 22.w, endIndent: 22.w),
          RadiusInkWellWidget(
              onPressed: () {
                Get.back(result: 10);
              },
              radius: 0,
              color: Colors.transparent,
              child: Container(
                  height: 60.h,
                  alignment: Alignment.center,
                  child: Text("10分钟", style: GoogleFonts.roboto(color: ColorUtil.color_333333, fontSize: 18.sp)))),
          Divider(height: 0, indent: 22.w, endIndent: 22.w),
          GestureDetector(
              onTap: Get.back,
              behavior: HitTestBehavior.translucent,
              child: Container(
                  height: 60.h,
                  alignment: Alignment.center,
                  child: Text("取消", style: GoogleFonts.roboto(color: ColorUtil.color_999999, fontSize: 18.sp)))),
          SizedBox(height: DeviceUtils.bottomSafeHeight)
        ]));
  }
}
