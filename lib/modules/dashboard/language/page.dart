import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vura/global/icon_font.dart';
import 'package:vura/utils/color_util.dart';
import 'package:vura/widgets/obx_widget.dart';
import 'package:vura/widgets/radius_inkwell_widget.dart';

import 'logic.dart';

class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key});

  LanguageLogic get logic => Get.find<LanguageLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("语言设置"), centerTitle: true),
        body: BaseWidget(
            logic: logic,
            builder: (logic) {
              return Column(children: [
                Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(11.r), color: Colors.white),
                    margin: EdgeInsets.symmetric(horizontal: 22.w, vertical: 22.h),
                    child: Column(children: [
                      RadiusInkWellWidget(
                          color: Colors.transparent,
                          onPressed: () {},
                          borderRadius:
                              BorderRadius.only(topLeft: Radius.circular(11.r), topRight: Radius.circular(11.r)),
                          child: Container(
                              height: 60.h,
                              padding: EdgeInsets.only(left: 22.w, right: 30.w),
                              child: Row(children: [
                                Text("简体中文", style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_333333)),
                                const Spacer(),
                                Icon(IconFont.check, size: 15.r)
                              ]))),
                      Divider(height: 0, indent: 22.w, endIndent: 22.w),
                      RadiusInkWellWidget(
                          color: Colors.transparent,
                          radius: 0,
                          onPressed: () {},
                          child: Container(
                              height: 60.h,
                              padding: EdgeInsets.only(left: 22.w, right: 30.w),
                              child: Row(children: [
                                Text("繁体中文", style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_333333)),
                                const Spacer(),
                                Icon(IconFont.check, size: 15.r)
                              ]))),
                      Divider(height: 0, indent: 22.w, endIndent: 22.w),
                      RadiusInkWellWidget(
                          color: Colors.transparent,
                          borderRadius:
                              BorderRadius.only(bottomLeft: Radius.circular(11.r), bottomRight: Radius.circular(11.r)),
                          onPressed: () {},
                          child: Container(
                              height: 60.h,
                              padding: EdgeInsets.only(left: 22.w, right: 30.w),
                              child: Row(children: [
                                Text("English",
                                    style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_333333)),
                                const Spacer(),
                                Icon(IconFont.check, size: 15.r)
                              ])))
                    ]))
              ]);
            }));
  }
}
