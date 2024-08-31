import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vura/global/icon_font.dart';
import 'package:vura/route/route_path.dart';
import 'package:vura/utils/color_util.dart';
import 'package:vura/widgets/widgets.dart';

import 'logic.dart';

class ChargeWayPage extends StatelessWidget {
  const ChargeWayPage({super.key});

  ChargeWayLogic get logic => Get.find<ChargeWayLogic>();

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
          appBar: AppBar(title: const Text("添加收款方式"), backgroundColor: Colors.transparent, centerTitle: true),
          body: BaseWidget(
              logic: logic,
              showEmpty: false,
              showError: false,
              builder: (logic) {
                return Column(children: [
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.only(topLeft: Radius.circular(10.r), topRight: Radius.circular(10.r))),
                      margin: EdgeInsets.only(top: 22.h, left: 22.w, right: 22.w),
                      height: 62.w,
                      width: double.infinity,
                      child: Stack(children: [
                        Positioned(
                            right: 0,
                            top: 0,
                            bottom: 0,
                            child: Image.asset("assets/images/bg-2.png", height: 62.w, fit: BoxFit.fitHeight)),
                        Container(
                            width: 217.w,
                            alignment: Alignment.center,
                            child: Text("K豆钱包",
                                style: GoogleFonts.roboto(
                                    color: const Color(0xff2ECC72), fontWeight: FontWeight.bold, fontSize: 18.sp))),
                        Positioned(
                            right: 0,
                            top: 0,
                            bottom: 0,
                            child: Container(
                                width: 130.w,
                                alignment: Alignment.center,
                                child: Text("K豆钱包",
                                    style: GoogleFonts.roboto(color: ColorUtil.color_999999, fontSize: 15.sp))))
                      ])),
                  const Divider(height: 0),
                  Container(
                      padding: EdgeInsets.only(top: 22.h),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.only(bottomLeft: Radius.circular(10.r), bottomRight: Radius.circular(10.r))),
                      margin: EdgeInsets.only(left: 22.w, right: 22.w),
                      child: Column(children: [
                        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                          Column(mainAxisSize: MainAxisSize.min, children: [
                            CustomIconButton(
                                icon: Icon(IconFont.download, size: 26.sp),
                                radius: 27.w,
                                bgColor: const Color(0xffF1FAEF)),
                            SizedBox(height: 11.h),
                            Text("K豆钱包下载1", style: GoogleFonts.roboto(fontSize: 11.sp, color: ColorUtil.color_333333))
                          ]),
                          Column(mainAxisSize: MainAxisSize.min, children: [
                            CustomIconButton(
                                icon: Icon(IconFont.download, size: 26.sp),
                                radius: 27.w,
                                bgColor: const Color(0xffF1FAEF)),
                            SizedBox(height: 11.h),
                            Text("K豆钱包下载2", style: GoogleFonts.roboto(fontSize: 11.sp, color: ColorUtil.color_333333))
                          ]),
                          Column(mainAxisSize: MainAxisSize.min, children: [
                            CustomIconButton(
                                icon: Icon(IconFont.download, size: 26.sp),
                                radius: 27.w,
                                bgColor: const Color(0xffF1FAEF)),
                            SizedBox(height: 11.h),
                            Text("K豆钱包下载3", style: GoogleFonts.roboto(fontSize: 11.sp, color: ColorUtil.color_333333))
                          ])
                        ]),
                        SizedBox(
                            width: double.infinity,
                            height: 300.h,
                            child: logic.list.isNotEmpty
                                ? Container()
                                : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                    Image.asset("assets/images/empty.webp", width: 177.w, height: 177.w),
                                    SizedBox(height: 11.h),
                                    Text("暂无数据",
                                        style: GoogleFonts.roboto(color: ColorUtil.color_999999, fontSize: 13.sp))
                                  ]))
                      ])),
                  RadiusInkWellWidget(
                      border: Border.all(width: 1, color: Theme.of(context).primaryColor),
                      radius: 40,
                      onPressed: () {
                        Get.toNamed(RoutePath.ADD_CHARGE_WAY_PAGE);
                      },
                      margin: EdgeInsets.only(top: 44.h),
                      child: Container(
                          height: 53.h,
                          width: 180.w,
                          alignment: Alignment.center,
                          child: Text("新增收款方式",
                              style: GoogleFonts.roboto(
                                  color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.sp))))
                ]);
              }))
    ]);
  }
}
