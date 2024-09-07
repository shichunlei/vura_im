import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vura/global/icon_font.dart';
import 'package:vura/modules/root/logic.dart';
import 'package:vura/utils/color_util.dart';
import 'package:vura/utils/device_utils.dart';
import 'package:vura/utils/string_util.dart';

import 'logic.dart';

class InputPayPasswordDialog extends StatelessWidget {
  final double? amount;
  final String? title;
  final String? tip;
  final bool isUsdt;
  final bool showAccount;

  const InputPayPasswordDialog(
      {super.key, this.amount, this.title, this.tip, this.isUsdt = false, this.showAccount = false});

  InputPayPasswordLogic get logic => Get.put(InputPayPasswordLogic());

  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          Expanded(
              child: GestureDetector(
                  onTap: Get.back,
                  behavior: HitTestBehavior.translucent,
                  child: const SizedBox(height: double.infinity, width: double.infinity))),
          Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20.r), topRight: Radius.circular(20.r)),
                  color: Colors.white),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Container(
                    padding: EdgeInsets.only(left: 11.w), alignment: Alignment.centerLeft, child: const CloseButton()),
                SizedBox(height: 22.h),
                Text("$title", style: GoogleFonts.roboto(color: ColorUtil.color_333333, fontSize: 14.sp)),
                SizedBox(height: 4.h),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Visibility(
                          visible: !isUsdt,
                          child: Text("￥",
                              style: GoogleFonts.roboto(
                                  color: const Color(0xffDB5549), fontSize: 22.sp, fontWeight: FontWeight.bold))),
                      Text("$amount",
                          style: GoogleFonts.roboto(
                              color: const Color(0xffDB5549), fontSize: 44.sp, fontWeight: FontWeight.bold)),
                      Visibility(
                          visible: isUsdt,
                          child: Text("u",
                              style: GoogleFonts.roboto(
                                  color: const Color(0xffDB5549), fontSize: 22.sp, fontWeight: FontWeight.bold)))
                    ]),
                ...showAccount
                    ? [
                        SizedBox(height: 11.h),
                        Container(
                            padding: EdgeInsets.only(left: 22.w),
                            alignment: Alignment.centerLeft,
                            child: Text("$tip",
                                style: GoogleFonts.roboto(color: ColorUtil.color_333333, fontSize: 14.sp))),
                        Container(
                            margin: EdgeInsets.symmetric(vertical: 22.h, horizontal: 22.w),
                            padding: EdgeInsets.symmetric(horizontal: 13.w),
                            height: 62.h,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(11.r),
                                border: Border.all(width: 1, color: const Color(0xffF1F6F7))),
                            child: Row(children: [
                              Image.asset("assets/images/USDT.png", width: 44.r, height: 44.r),
                              SizedBox(width: 13.w),
                              Expanded(
                                  child: Text(Get.find<RootLogic>().user.value?.walletCard ?? "未设置$tip",
                                      style: GoogleFonts.dmSans(
                                          color: ColorUtil.color_333333,
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold))),
                              Icon(IconFont.check, size: 15.sp)
                            ]))
                      ]
                    : [],
                SizedBox(height: 11.h),
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
                    ])),
                SizedBox(height: DeviceUtils.setBottomMargin(22.h))
              ]))
        ]));
  }
}
