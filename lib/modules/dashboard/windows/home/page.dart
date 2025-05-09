import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vura/route/route_path.dart';
import 'package:vura/utils/color_util.dart';
import 'package:vura/widgets/radius_inkwell_widget.dart';

import 'logic.dart';

class WindowsPage extends StatelessWidget {
  const WindowsPage({super.key});

  WindowsLogic get logic => Get.find<WindowsLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Interface".tr), centerTitle: true),
        body: Column(children: [
          Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(11.r), color: Colors.white),
              margin: EdgeInsets.symmetric(horizontal: 22.w, vertical: 22.h),
              child: Column(children: [
                RadiusInkWellWidget(
                    color: Colors.transparent,
                    onPressed: () {
                      Get.toNamed(RoutePath.CHAT_BACKGROUND_PAGE);
                    },
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(11.r), topRight: Radius.circular(11.r)),
                    child: Container(
                        height: 60.h,
                        padding: EdgeInsets.only(left: 22.w, right: 10.w),
                        child: Row(children: [
                          Text("Chat Background".tr,
                              style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_333333)),
                          const Spacer(),
                          const Icon(Icons.keyboard_arrow_right, color: ColorUtil.color_999999)
                        ]))),
                Divider(height: 0, indent: 22.w, endIndent: 22.w),
                RadiusInkWellWidget(
                    color: Colors.transparent,
                    borderRadius:
                        BorderRadius.only(bottomLeft: Radius.circular(11.r), bottomRight: Radius.circular(11.r)),
                    onPressed: () {
                      Get.toNamed(RoutePath.FONT_SIZE_PAGE);
                    },
                    child: Container(
                        height: 60.h,
                        padding: EdgeInsets.only(left: 22.w, right: 10.w),
                        child: Row(children: [
                          Text("Text Size".tr,
                              style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_333333)),
                          const Spacer(),
                          const Icon(Icons.keyboard_arrow_right, color: ColorUtil.color_999999)
                        ])))
              ]))
        ]));
  }
}
