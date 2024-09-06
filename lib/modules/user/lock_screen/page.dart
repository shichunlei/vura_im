import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gesture_password_widget/widget/gesture_password_widget.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vura/global/enum.dart';
import 'package:vura/global/icon_font.dart';
import 'package:vura/utils/color_util.dart';
import 'package:vura/utils/device_utils.dart';
import 'package:vura/utils/string_util.dart';
import 'package:vura/widgets/radius_inkwell_widget.dart';

import 'logic.dart';

class LockScreenPage extends StatelessWidget {
  const LockScreenPage({super.key});

  LockScreenLogic get logic => Get.find<LockScreenLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Stack(children: [
          Obx(() {
            return Center(
                child: logic.type.value == CheckPasswordType.numberPassword
                    ? Container(
                        margin: EdgeInsets.only(bottom: 120.h),
                        height: 53.h,
                        width: double.infinity,
                        child: Stack(children: [
                          Center(
                              child: Wrap(
                                  spacing: 12.w,
                                  children: List.generate(
                                      logic.maxCount,
                                      (index) => Container(
                                          height: 53.h,
                                          width: 44.w,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8.r), color: const Color(0xffF7F8F8)),
                                          child: Obx(() {
                                            return StringUtil.isNotEmpty(logic.codeList[index])
                                                ? Icon(IconFont.star, size: 15.sp, color: ColorUtil.color_333333)
                                                : const SizedBox();
                                          }))))),
                          Container(
                              alignment: Alignment.center,
                              height: 53.h,
                              child: Opacity(
                                  opacity: 0,
                                  child: TextField(
                                      autofocus: true,
                                      controller: logic.controller,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly, //只输入数字
                                        LengthLimitingTextInputFormatter(logic.maxCount) //限制长度
                                      ],
                                      onChanged: (value) => logic.textChange(context, value),
                                      keyboardType: TextInputType.number)))
                        ]))
                    : GesturePasswordWidget(
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
                        onComplete: logic.onComplete,
                        completeWaitMilliseconds: 100,
                        answer: logic.gestureData));
          }),
          Positioned(
              left: 0,
              right: 0,
              top: DeviceUtils.navigationBarHeight + 44.h,
              child: Container(
                  alignment: Alignment.center,
                  child: Text("解锁密码",
                      style: GoogleFonts.dmSans(
                          color: ColorUtil.color_333333, fontWeight: FontWeight.bold, fontSize: 22.sp)))),
          Positioned(
              bottom: 0,
              left: 108.w,
              right: 108.w,
              child: Obx(() {
                return Visibility(
                    visible: logic.isToggle.value,
                    child: Center(
                        child: SafeArea(
                            top: false,
                            child: RadiusInkWellWidget(
                                radius: 40,
                                margin: EdgeInsets.only(bottom: 44.h),
                                onPressed: logic.updateCheckType,
                                child: Container(
                                    height: 45.h,
                                    alignment: Alignment.center,
                                    child: Text(
                                        logic.type.value == CheckPasswordType.gesturePassword ? "切换数字密码" : "切换图案密码",
                                        style: GoogleFonts.roboto(
                                            color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16.sp)))))));
              }))
        ]));
  }
}
