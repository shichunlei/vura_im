import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vura/utils/device_utils.dart';
import 'package:vura/widgets/radius_inkwell_widget.dart';

import 'logic.dart';

class FontSizeSettingPage extends StatelessWidget {
  const FontSizeSettingPage({super.key});

  FontSizeSettingLogic get logic => Get.find<FontSizeSettingLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("字体大小设置"), actions: [
          Center(
              child: RadiusInkWellWidget(
                  radius: 4.r,
                  margin: EdgeInsets.only(right: 11.w),
                  child: Container(
                      alignment: Alignment.center,
                      height: 30.h,
                      width: 50.w,
                      child: Text("完成", style: GoogleFonts.roboto(fontSize: 15.sp, color: Colors.white))),
                  onPressed: () {}))
        ]),
        body: Column(children: [
          Expanded(child: Container()),
          Container(height: 100.h, color: Colors.white, padding: EdgeInsets.only(bottom: DeviceUtils.bottomSafeHeight))
        ]));
  }
}
