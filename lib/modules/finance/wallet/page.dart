import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vura/global/icon_font.dart';
import 'package:vura/route/route_path.dart';
import 'package:vura/utils/color_util.dart';
import 'package:vura/widgets/widgets.dart';

import 'logic.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  WalletLogic get logic => Get.find<WalletLogic>();

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
          appBar: AppBar(title: const Text("USDT钱包"), backgroundColor: Colors.transparent, centerTitle: true),
          body: BaseWidget(
              logic: logic,
              showEmpty: false,
              builder: (logic) {
                return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Center(
                      child: SizedBox(
                          width: 265.w,
                          child: AspectRatio(aspectRatio: 1, child: Image.asset("assets/images/jinbi.png")))),
                  Row(children: [
                    SizedBox(width: 22.w),
                    Column(mainAxisSize: MainAxisSize.min, children: [
                      Text("USDT数量:", style: GoogleFonts.dmSans(fontSize: 13.sp, color: ColorUtil.color_999999)),
                      SizedBox(height: 13.h),
                      Text("0.00",
                          style: GoogleFonts.roboto(
                              color: ColorUtil.color_333333, fontSize: 18.sp, fontWeight: FontWeight.bold))
                    ]),
                    const Spacer(),
                    Text("≈￥0.00",
                        style: GoogleFonts.roboto(
                            color: ColorUtil.color_333333, fontSize: 26.sp, fontWeight: FontWeight.bold)),
                    SizedBox(width: 22.w)
                  ]),
                  Container(
                      margin: EdgeInsets.only(top: 22.h, left: 22.w, right: 22.w),
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(18.r), color: const Color(0xff83C240)),
                      height: 93.h,
                      child: Row(children: [
                        Expanded(
                            child: GestureDetector(
                                onTap: () {
                                  Get.toNamed(RoutePath.RECHARGE_PAGE);
                                },
                                behavior: HitTestBehavior.translucent,
                                child: Column(mainAxisSize: MainAxisSize.min, children: [
                                  Icon(IconFont.buy_coins, color: Colors.white, size: 35.sp),
                                  Text("购买币", style: GoogleFonts.dmSans(fontSize: 13.sp, color: Colors.white))
                                ]))),
                        Container(
                            margin: EdgeInsets.symmetric(vertical: 15.h),
                            height: double.infinity,
                            width: 1,
                            decoration: const BoxDecoration(
                                gradient:
                                    LinearGradient(colors: [Colors.transparent, Colors.white, Colors.transparent]))),
                        Expanded(
                            child: GestureDetector(
                                onTap: () {
                                  Get.toNamed(RoutePath.WITHDRAW_PAGE);
                                },
                                behavior: HitTestBehavior.translucent,
                                child: Column(mainAxisSize: MainAxisSize.min, children: [
                                  Icon(IconFont.sell_coins, color: Colors.white, size: 35.sp),
                                  Text("出售币", style: GoogleFonts.dmSans(fontSize: 13.sp, color: Colors.white))
                                ])))
                      ])),
                  Container(
                      margin: EdgeInsets.only(top: 22.h, left: 22.w, right: 22.w, bottom: 22.h),
                      child: Row(children: [
                        Text("收支明细",
                            style: GoogleFonts.roboto(
                                color: ColorUtil.color_333333, fontSize: 18.sp, fontWeight: FontWeight.bold)),
                        const Spacer(),
                        Text("类型:", style: GoogleFonts.roboto(color: ColorUtil.color_333333, fontSize: 13.sp)),
                        Text("全部", style: GoogleFonts.roboto(color: ColorUtil.color_333333, fontSize: 13.sp)),
                        Icon(Icons.keyboard_arrow_down, size: 15.sp),
                        SizedBox(width: 5.w),
                        Icon(IconFont.time, color: ColorUtil.color_333333, size: 22.sp)
                      ])),
                  ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 22.w),
                      itemBuilder: (_, index) {
                        return Container(
                            padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 20.h),
                            decoration:
                                BoxDecoration(borderRadius: BorderRadius.circular(9.r), color: const Color(0xfff5f5f5)),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Row(children: [
                                Text("${logic.list[index].walletCard}",
                                    style: GoogleFonts.dmSans(
                                        fontSize: 18.sp, color: ColorUtil.color_333333, fontWeight: FontWeight.bold)),
                                const Spacer(),
                                Text(
                                    logic.list[index].type == "INCOME"
                                        ? "+${logic.list[index].money} USDT"
                                        : "-${logic.list[index].money} USDT",
                                    style: GoogleFonts.dmSans(
                                        fontSize: 18.sp,
                                        color: logic.list[index].type == "INCOME"
                                            ? const Color(0xff2ECC72)
                                            : const Color(0xffFF4255),
                                        fontWeight: FontWeight.bold))
                              ]),
                              SizedBox(height: 3.h),
                              Row(children: [
                                Text("${logic.list[index].detailDesc}",
                                    style: GoogleFonts.dmSans(fontSize: 13.sp, color: ColorUtil.color_999999)),
                                const Spacer(),
                                Text("≈￥${logic.list[index].money}",
                                    style: GoogleFonts.dmSans(fontSize: 13.sp, color: ColorUtil.color_999999))
                              ]),
                              SizedBox(height: 3.h),
                              Text("${logic.list[index].updateTime}",
                                  style: GoogleFonts.dmSans(fontSize: 13.sp, color: ColorUtil.color_999999))
                            ]));
                      },
                      separatorBuilder: (_, index) {
                        return SizedBox(height: 11.h);
                      },
                      itemCount: logic.list.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics())
                ]);
              }))
    ]);
  }
}
