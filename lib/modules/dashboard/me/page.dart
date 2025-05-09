import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vura/global/icon_font.dart';
import 'package:vura/global/keys.dart';
import 'package:vura/modules/root/logic.dart';
import 'package:vura/route/route_path.dart';
import 'package:vura/utils/color_util.dart';
import 'package:vura/utils/dialog_util.dart';
import 'package:vura/utils/string_util.dart';
import 'package:vura/utils/tool_util.dart';
import 'package:vura/widgets/widgets.dart';

import 'logic.dart';

class MinePage extends StatelessWidget {
  const MinePage({super.key});

  MineLogic get logic => Get.find<MineLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorUtil.secondBgColor,
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text("mine".tr),
            actions: [
              CustomIconButton(icon: const Icon(IconFont.scan, color: ColorUtil.color_333333), onPressed: logic.scan),
              CustomIconButton(
                  icon: const Icon(IconFont.qr, color: ColorUtil.color_333333),
                  onPressed: () {
                    Get.toNamed(RoutePath.MY_QR_CODE_PAGE, arguments: {Keys.ID: Get.find<RootLogic>().user.value?.id});
                  })
            ],
            centerTitle: false),
        body: SingleChildScrollView(
          child: Obx(() {
            return Column(children: [
              SizedBox(height: 32.h),
              GestureDetector(
                  onTap: () {
                    Get.toNamed(RoutePath.MY_INFO_PAGE);
                  },
                  behavior: HitTestBehavior.translucent,
                  child: Row(children: [
                    SizedBox(width: 22.w),
                    AvatarImageView("${Get.find<RootLogic>().user.value?.headImageThumb}",
                        radius: 33.r, name: Get.find<RootLogic>().user.value?.nickName),
                    SizedBox(width: 22.w),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        SizedBox(height: 11.h),
                        Text("${Get.find<RootLogic>().user.value?.nickName}",
                            style: GoogleFonts.dmSans(
                                fontSize: 18.sp, color: ColorUtil.color_333333, fontWeight: FontWeight.bold)),
                        Row(children: [
                          Text("id".trParams({"number": "${Get.find<RootLogic>().user.value?.no}"}),
                              style: GoogleFonts.dmSans(fontSize: 13.sp, color: ColorUtil.color_999999)),
                          SizedBox(width: 22.w),
                          GestureDetector(
                              onTap: () {
                                /// 复制ID号
                                copyToClipboard("${Get.find<RootLogic>().user.value?.no}");
                              },
                              child: Icon(IconFont.copy, size: 15.sp, color: ColorUtil.color_999999))
                        ]),
                        SizedBox(height: 11.h)
                      ]),
                    ),
                    const Icon(Icons.keyboard_arrow_right, color: ColorUtil.color_999999),
                    SizedBox(width: 18.w)
                  ])),
              SizedBox(height: 22.h),
              GestureDetector(
                onTap: () {
                  Get.toNamed(RoutePath.WALLET_PAGE);
                },
                behavior: HitTestBehavior.translucent,
                child: Container(
                    decoration:
                        BoxDecoration(color: ColorUtil.mainColor, borderRadius: BorderRadius.circular(20.r)),
                    margin: EdgeInsets.symmetric(horizontal: 22.w),
                    padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 22.h),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Row(children: [
                        GestureDetector(
                            onTap: logic.showMoney.toggle,
                            behavior: HitTestBehavior.translucent,
                            child: Row(mainAxisSize: MainAxisSize.min, children: [
                              Text("总资产", style: GoogleFonts.dmSans(fontSize: 13.sp, color: Colors.white)),
                              SizedBox(width: 20.w),
                              Icon(logic.showMoney.value ? IconFont.eye_open_fill : IconFont.eye_close_fill,
                                  color: Colors.white, size: 15.sp)
                            ])),
                        const Spacer(),
                        const Icon(IconFont.idcard),
                        SizedBox(width: 10.w)
                      ]),
                      SizedBox(height: 20.h),
                      Row(children: [
                        Container(
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(9.r)),
                            alignment: Alignment.center,
                            width: 35.r,
                            height: 35.r,
                            child: Icon(IconFont.usdt, size: 22.sp)),
                        SizedBox(width: 13.w),
                        Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                          Text("USDT",
                              style: GoogleFonts.dmSans(
                                  fontSize: 15.sp, color: Colors.white, fontWeight: FontWeight.bold)),
                          SizedBox(height: 5.h),
                          SizedBox(
                              height: 15.h,
                              child: Text(
                                  logic.showMoney.value
                                      ? "${Get.find<RootLogic>().exchangeRate.value} RMB"
                                      : "****", // todo 汇率
                                  style: GoogleFonts.dmSans(fontSize: 11.sp, color: Colors.white)))
                        ]),
                        const Spacer(),
                        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                          Text(logic.showMoney.value ? "${Get.find<RootLogic>().user.value?.money}" : "****",
                              style: GoogleFonts.daiBannaSil(
                                  fontSize: 15.sp, color: Colors.white, fontWeight: FontWeight.bold)),
                          SizedBox(height: 5.h),
                          SizedBox(
                              height: 15.h,
                              child: Text(
                                  logic.showMoney.value
                                      ? "≈￥${StringUtil.formatPrice(Get.find<RootLogic>().exchangeRate.value * Get.find<RootLogic>().user.value!.money)}"
                                      : "****",
                                  style: GoogleFonts.daiBannaSil(fontSize: 11.sp, color: Colors.white)))
                        ])
                      ])
                    ])),
              ),
              Container(
                  height: 66.h,
                  padding: EdgeInsets.only(top: 22.h, left: 22.w),
                  alignment: Alignment.centerLeft,
                  child: Text("other".tr,
                      style: GoogleFonts.dmSans(
                          fontSize: 18.sp, color: ColorUtil.color_333333, fontWeight: FontWeight.bold))),
              Row(children: [
                SizedBox(width: 22.w),
                Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center, children: [
                  RadiusInkWellWidget(
                      onPressed: () {
                        Get.toNamed(RoutePath.CHARGE_WAY_PAGE);
                      },
                      radius: 18.r,
                      color: Colors.white,
                      child: Container(
                          alignment: Alignment.center,
                          height: 62.r,
                          width: 62.r,
                          child: Icon(IconFont.charge_way, size: 26.r))),
                  SizedBox(height: 13.h),
                  Text("收款方式", style: GoogleFonts.dmSans(fontSize: 13.sp, color: const Color(0xff030319)))
                ]),
                const Spacer(),
                Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center, children: [
                  RadiusInkWellWidget(
                      onPressed: () {
                        if (StringUtil.isEmpty(Get.find<RootLogic>().user.value?.walletCard)) {
                          show(builder: (_) {
                            return CustomAlertDialog(
                                title: "温馨提示",
                                content: "您还没有设置收款方式，请先设置收款方式，去设置收款方式？",
                                confirmText: "立刻去",
                                cancelText: "稍等会儿",
                                onConfirm: () {
                                  Get.toNamed(RoutePath.CHARGE_WAY_PAGE);
                                });
                          });
                          return;
                        }
                        Get.toNamed(RoutePath.CHARGE_PAGE);
                      },
                      radius: 18.r,
                      color: Colors.white,
                      child: Container(
                          alignment: Alignment.center,
                          height: 62.r,
                          width: 62.r,
                          child: Icon(IconFont.charge, size: 26.r))),
                  SizedBox(height: 13.h),
                  Text("收款", style: GoogleFonts.dmSans(fontSize: 13.sp, color: const Color(0xff030319)))
                ]),
                const Spacer(),
                Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center, children: [
                  RadiusInkWellWidget(
                      onPressed: () {
                        Get.toNamed(RoutePath.TRANSFER_PAGE);
                      },
                      radius: 18.r,
                      color: Colors.white,
                      child: Container(
                          alignment: Alignment.center,
                          height: 62.r,
                          width: 62.r,
                          child: Icon(IconFont.transfer, size: 26.r))),
                  SizedBox(height: 13.h),
                  Text("Transfer".tr, style: GoogleFonts.dmSans(fontSize: 13.sp, color: const Color(0xff030319)))
                ]),
                const Spacer(),
                Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center, children: [
                  RadiusInkWellWidget(
                      onPressed: () {
                        Get.toNamed(RoutePath.DEVICES_PAGE);
                      },
                      radius: 18.r,
                      color: Colors.white,
                      child: Container(
                          alignment: Alignment.center,
                          height: 62.r,
                          width: 62.r,
                          child: Icon(IconFont.device, size: 26.r))),
                  SizedBox(height: 13.h),
                  Text("device".tr, style: GoogleFonts.dmSans(fontSize: 13.sp, color: const Color(0xff030319)))
                ]),
                SizedBox(width: 22.w)
              ]),
              SizedBox(height: 22.h),
              Row(children: [
                SizedBox(width: 22.w),
                Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center, children: [
                  RadiusInkWellWidget(
                      onPressed: () {
                        Get.toNamed(RoutePath.NOTICE_SETTING_PAGE);
                      },
                      radius: 18.r,
                      color: Colors.white,
                      child: Container(
                          alignment: Alignment.center,
                          height: 62.r,
                          width: 62.r,
                          child: Icon(IconFont.notice, size: 26.r))),
                  SizedBox(height: 13.h),
                  Text("Notice".tr, style: GoogleFonts.dmSans(fontSize: 13.sp, color: const Color(0xff030319)))
                ]),
                const Spacer(),
                Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center, children: [
                  RadiusInkWellWidget(
                      onPressed: () {
                        Get.toNamed(RoutePath.PRIVACY_PAGE);
                      },
                      radius: 18.r,
                      color: Colors.white,
                      child: Container(
                          alignment: Alignment.center,
                          height: 62.r,
                          width: 62.r,
                          child: Icon(IconFont.privacy, size: 26.r))),
                  SizedBox(height: 13.h),
                  Text("privacy".tr, style: GoogleFonts.dmSans(fontSize: 13.sp, color: const Color(0xff030319)))
                ]),
                const Spacer(),
                Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center, children: [
                  RadiusInkWellWidget(
                      onPressed: () {
                        Get.toNamed(RoutePath.WINDOWS_PAGE);
                      },
                      radius: 18.r,
                      color: Colors.white,
                      child: Container(
                          alignment: Alignment.center,
                          height: 62.r,
                          width: 62.r,
                          child: Icon(IconFont.windows, size: 26.r))),
                  SizedBox(height: 13.h),
                  Text("Interface".tr, style: GoogleFonts.dmSans(fontSize: 13.sp, color: const Color(0xff030319)))
                ]),
                const Spacer(),
                Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center, children: [
                  RadiusInkWellWidget(
                      onPressed: () {
                        Get.toNamed(RoutePath.LANGUAGE_PAGE);
                      },
                      radius: 18.r,
                      color: Colors.white,
                      child: Container(
                          alignment: Alignment.center,
                          height: 62.r,
                          width: 62.r,
                          child: Icon(IconFont.language, size: 26.r))),
                  SizedBox(height: 13.h),
                  Text("language".tr, style: GoogleFonts.dmSans(fontSize: 13.sp, color: const Color(0xff030319)))
                ]),
                SizedBox(width: 22.w)
              ]),
              RadiusInkWellWidget(
                  color: const Color(0xffF2F2F2),
                  onPressed: () {
                    Get.toNamed(RoutePath.SETTING_PAGE);
                  },
                  radius: 10.r,
                  margin: EdgeInsets.symmetric(horizontal: 22.w, vertical: 22.h),
                  child: Container(
                      height: 118.h,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                          color: Colors.white, image: DecorationImage(image: AssetImage("assets/images/setting.png"))),
                      child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 22.h),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text('setting'.tr,
                                style: GoogleFonts.dmSans(
                                    fontSize: 18.sp, color: ColorUtil.color_333333, fontWeight: FontWeight.bold)),
                            SizedBox(height: 15.h),
                            Text("基础设置都在这里奥~",
                                style: GoogleFonts.dmSans(fontSize: 13.sp, color: ColorUtil.color_999999))
                          ])))),
              SizedBox(height: 35.h)
            ]);
          }),
        ));
  }
}
