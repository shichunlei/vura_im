import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vura/global/icon_font.dart';
import 'package:vura/utils/color_util.dart';
import 'package:vura/utils/string_util.dart';

import 'logic.dart';

class SetNumberPasswordPage extends StatelessWidget {
  const SetNumberPasswordPage({super.key});

  SetNumberPasswordLogic get logic => Get.find<SetNumberPasswordLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(),
        body: Column(children: [
          Container(
              margin: EdgeInsets.only(top: 22.h, left: 44.w),
              alignment: Alignment.centerLeft,
              child: Obx(() {
                return Text(logic.reInput.value ? "再次确认锁屏密码" : "请设置6位锁屏密码",
                    style: GoogleFonts.dmSans(
                        color: ColorUtil.color_333333, fontWeight: FontWeight.bold, fontSize: 22.sp));
              })),
          Container(
              margin: EdgeInsets.only(top: 13.h, left: 44.w, bottom: 35.h),
              alignment: Alignment.centerLeft,
              child: Text(logic.reInput.value ? "请确认刚才输入的锁屏密码" : "请输入锁屏密码",
                  style: GoogleFonts.dmSans(color: ColorUtil.color_333333, fontSize: 13.sp))),
          SizedBox(
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
        ]));
  }
}
