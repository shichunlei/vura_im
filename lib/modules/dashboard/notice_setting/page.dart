import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vura/utils/color_util.dart';

import 'logic.dart';

class NoticeSettingPage extends StatelessWidget {
  const NoticeSettingPage({super.key});

  NoticeSettingLogic get logic => Get.find<NoticeSettingLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Message Notifications".tr), centerTitle: true),
        body: Column(children: [
          Obx(() {
            return Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(11.r), color: Colors.white),
                margin: EdgeInsets.symmetric(horizontal: 22.w, vertical: 11.h),
                child: Column(children: [
                  Container(
                      height: 60.h,
                      padding: EdgeInsets.only(left: 22.w, right: 15.w),
                      child: Row(children: [
                        Text("New Message Alerts".tr,
                            style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_333333)),
                        const Spacer(),
                        CupertinoSwitch(value: logic.isNotice.value, onChanged: (value) => logic.isNotice.toggle())
                      ])),
                  Visibility(
                      visible: logic.isNotice.value,
                      child: Column(children: [
                        Divider(height: 0, indent: 22.w, endIndent: 22.w),
                        Container(
                            height: 60.h,
                            padding: EdgeInsets.only(left: 22.w, right: 15.w),
                            child: Row(children: [
                              Text("Sound".tr,
                                  style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_333333)),
                              const Spacer(),
                              CupertinoSwitch(value: logic.voice.value, onChanged: (value) => logic.voice.toggle())
                            ])),
                        Divider(height: 0, indent: 22.w, endIndent: 22.w),
                        Container(
                            height: 60.h,
                            padding: EdgeInsets.only(left: 22.w, right: 15.w),
                            child: Row(children: [
                              Text("In-App Vibrate".tr,
                                  style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_333333)),
                              const Spacer(),
                              CupertinoSwitch(value: logic.shock.value, onChanged: (value) => logic.shock.toggle())
                            ]))
                      ]))
                ]));
          })
        ]));
  }
}
