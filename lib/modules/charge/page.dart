import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:im/utils/color_util.dart';
import 'package:im/widgets/widgets.dart';

import 'logic.dart';

class ChargePage extends StatelessWidget {
  const ChargePage({super.key});

  ChargeLogic get logic => Get.find<ChargeLogic>();

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xffC5E9C2), Color(0xfffafafa), Color(0xfffafafa), Color(0xfffafafa)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter))),
      Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(title: const Text("USDT收款"), backgroundColor: Colors.transparent, centerTitle: true),
          body: BaseWidget(
              logic: logic,
              builder: (logic) {
                return SingleChildScrollView(
                    padding: EdgeInsets.symmetric(vertical: 11.h, horizontal: 22.w),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Container(
                          width: double.infinity,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(22.r), color: Colors.white),
                          child: Column(children: [
                            SizedBox(height: 22.h),
                            Text("收款码", style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_333333)),
                            SizedBox(height: 22.h),
                            Container(height: 243.r, width: 243.r),
                            RadiusInkWellWidget(
                                radius: 40,
                                onPressed: () {},
                                margin: EdgeInsets.only(top: 22.h, bottom: 22.h),
                                child: Container(
                                    height: 44.h,
                                    width: 180.w,
                                    alignment: Alignment.center,
                                    child: Text("扫描二维码",
                                        style: GoogleFonts.roboto(
                                            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.sp)))),
                          ])),
                      Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 22.h),
                          margin: EdgeInsets.symmetric(vertical: 22.h),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(22.r), color: Colors.white),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text("收款地址",
                                style: GoogleFonts.roboto(
                                    fontSize: 18.sp, color: ColorUtil.color_333333, fontWeight: FontWeight.w600)),
                            SizedBox(height: 22.h),
                            Text("3443244234242343423",
                                style: GoogleFonts.roboto(
                                    fontSize: 13.sp, color: ColorUtil.color_999999, fontWeight: FontWeight.w600)),
                            Center(
                                child: RadiusInkWellWidget(
                                    border: Border.all(width: 1, color: Theme.of(context).primaryColor),
                                    radius: 40,
                                    color: Colors.transparent,
                                    onPressed: () {},
                                    margin: EdgeInsets.only(top: 22.h),
                                    child: Container(
                                        height: 44.h,
                                        width: 180.w,
                                        alignment: Alignment.center,
                                        child: Text("复制地址串",
                                            style: GoogleFonts.roboto(
                                                color: Theme.of(context).primaryColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18.sp))))),
                          ])),
                      Text("最小收款数为1.00USDT",
                          style: GoogleFonts.roboto(
                              color: ColorUtil.color_999999, fontWeight: FontWeight.w600, fontSize: 15.sp)),
                      SizedBox(height: 5.h),
                      Text("该地址仅用于USDT收款",
                          style: GoogleFonts.roboto(
                              color: ColorUtil.color_999999, fontWeight: FontWeight.w600, fontSize: 15.sp)),
                      SizedBox(height: 5.h),
                      Text("请勿用于其他币种，否则资产将不可找回",
                          style: GoogleFonts.roboto(
                              color: ColorUtil.color_999999, fontWeight: FontWeight.w600, fontSize: 15.sp)),
                    ]));
              }))
    ]);
  }
}
