import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vura/application.dart';
import 'package:vura/global/config.dart';
import 'package:vura/route/route_path.dart';
import 'package:vura/utils/color_util.dart';
import 'package:vura/utils/dialog_util.dart';
import 'package:vura/utils/sp_util.dart';
import 'package:vura/widgets/dialog/alert_dialog.dart';
import 'package:vura/widgets/radius_inkwell_widget.dart';

import 'logic.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  SettingLogic get logic => Get.find<SettingLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("通用设置"), centerTitle: true),
        body: Column(children: [
          SizedBox(height: 30.h),
          Image.asset("assets/images/logo.png", width: 88.r, height: 88.r),
          SizedBox(height: 10.h),
          Text("版本号：${AppConfig.version?.version}"),
          Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(11.r), color: Colors.white),
              margin: EdgeInsets.symmetric(horizontal: 22.w, vertical: 22.h),
              child: Column(children: [
                RadiusInkWellWidget(
                    color: Colors.transparent,
                    onPressed: () {
                      Get.toNamed(RoutePath.LINE_PAGE);
                    },
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(11.r), topRight: Radius.circular(11.r)),
                    child: Container(
                        height: 60.h,
                        padding: EdgeInsets.only(left: 22.w, right: 10.w),
                        child: Row(children: [
                          Text("请求线路", style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_333333)),
                          const Spacer(),
                          Text("线路2", style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_999999)),
                          const Icon(Icons.keyboard_arrow_right, color: ColorUtil.color_999999)
                        ]))),
                Divider(height: 0, indent: 22.w, endIndent: 22.w),
                RadiusInkWellWidget(
                    color: Colors.transparent,
                    borderRadius:
                        BorderRadius.only(bottomLeft: Radius.circular(11.r), bottomRight: Radius.circular(11.r)),
                    onPressed: () {
                      show(builder: (_) {
                        return CustomAlertDialog(title: "提示", content: "确定要清除缓存", onConfirm: logic.clearCache);
                      });
                    },
                    child: Container(
                        height: 60.h,
                        padding: EdgeInsets.only(left: 22.w, right: 10.w),
                        child: Row(children: [
                          Text("本地缓存", style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_333333)),
                          const Spacer(),
                          Obx(() {
                            return Text(logic.cacheSize.value,
                                style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_999999));
                          }),
                          const Icon(Icons.keyboard_arrow_right, color: ColorUtil.color_999999)
                        ])))
              ])),
          Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(11.r), color: Colors.white),
              margin: EdgeInsets.symmetric(horizontal: 22.w),
              child: Column(children: [
                RadiusInkWellWidget(
                    color: Colors.transparent,
                    onPressed: () {},
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(11.r), topRight: Radius.circular(11.r)),
                    child: Container(
                        height: 60.h,
                        padding: EdgeInsets.only(left: 22.w, right: 10.w),
                        child: Row(children: [
                          Text("官网主页",
                              style: GoogleFonts.roboto(
                                  fontSize: 15.sp, color: ColorUtil.color_333333, fontWeight: FontWeight.bold)),
                          const Spacer(),
                          Text("http://home.lgerapp.com",
                              style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_999999)),
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
                          Text("版本号",
                              style: GoogleFonts.roboto(
                                  fontSize: 15.sp, color: ColorUtil.color_333333, fontWeight: FontWeight.bold)),
                          const Spacer(),
                          Text("${AppConfig.version?.version}",
                              style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_999999)),
                          const Icon(Icons.keyboard_arrow_right, color: ColorUtil.color_999999)
                        ])))
              ])),
          RadiusInkWellWidget(
              margin: EdgeInsets.symmetric(horizontal: 22.w, vertical: 22.h),
              color: Colors.white,
              onPressed: () {
                Get.toNamed(RoutePath.ACCOUNT_PAGE);
              },
              radius: 11.r,
              child: Container(
                  height: 60.h,
                  padding: EdgeInsets.only(left: 22.w, right: 10.w),
                  child: Row(children: [
                    Text("账号管理",
                        style: GoogleFonts.roboto(
                            fontSize: 15.sp, color: ColorUtil.color_333333, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    const Icon(Icons.keyboard_arrow_right, color: ColorUtil.color_999999)
                  ]))),
          const Spacer(),
          RadiusInkWellWidget(
              margin: EdgeInsets.symmetric(horizontal: 22.w, vertical: 44.h),
              color: Colors.white,
              onPressed: () {
                SpUtil.clear();
                webSocketManager.close();
                Get.offAllNamed(RoutePath.LOGIN_PAGE);
              },
              radius: 11.r,
              child: Container(
                  height: 60.h,
                  padding: EdgeInsets.only(left: 22.w, right: 10.w),
                  alignment: Alignment.centerLeft,
                  child: Text("退出账号",
                      style: GoogleFonts.roboto(
                          fontSize: 15.sp, color: const Color(0xffDB5549), fontWeight: FontWeight.bold))))
        ]));
  }
}
