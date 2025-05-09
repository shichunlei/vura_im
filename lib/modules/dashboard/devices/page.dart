import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vura/global/icon_font.dart';
import 'package:vura/utils/color_util.dart';
import 'package:vura/utils/date_util.dart';
import 'package:vura/widgets/widgets.dart';

import 'logic.dart';

class DevicesPage extends StatelessWidget {
  const DevicesPage({super.key});

  DevicesLogic get logic => Get.find<DevicesLogic>();

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
          appBar: AppBar(title: Text("device".tr), backgroundColor: Colors.transparent, centerTitle: true, actions: [
            CustomIconButton(icon: Icon(IconFont.minus_user, size: 26.r), onPressed: () {}),
            CustomIconButton(icon: Icon(IconFont.edit, size: 26.r), onPressed: () {}),
          ]),
          body: BaseWidget(
              logic: logic,
              bgColor: Colors.transparent,
              showEmpty: false,
              builder: (logic) {
                return SingleChildScrollView(
                  child: Column(children: [
                    Stack(children: [
                      SizedBox(
                          width: 265.w,
                          child: AspectRatio(aspectRatio: 1, child: Image.asset("assets/images/phone.webp"))),
                      Positioned(
                          bottom: 11.h,
                          left: 0,
                          right: 0,
                          child: Container(
                              alignment: Alignment.center,
                              child: Text("扫描其他设备上的登录二维码",
                                  style: GoogleFonts.roboto(color: ColorUtil.color_999999, fontSize: 13.sp))))
                    ]),
                    RadiusInkWellWidget(
                        radius: 40,
                        onPressed: () {},
                        margin: EdgeInsets.only(top: 11.h),
                        child: Container(
                            height: 44.h,
                            width: 180.w,
                            alignment: Alignment.center,
                            child: Text("扫描二维码",
                                style: GoogleFonts.roboto(
                                    color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.sp)))),
                    Container(
                        margin: EdgeInsets.only(top: 22.h, left: 22.w, right: 22.w),
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 22.h),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(11.r)),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text("当前设备",
                              style: GoogleFonts.roboto(
                                  color: ColorUtil.color_333333, fontSize: 18.sp, fontWeight: FontWeight.w600)),
                          SizedBox(height: 22.h),
                          Row(children: [
                            Image.asset("assets/images/device.webp", width: 66.r, height: 66.r),
                            SizedBox(width: 13.w),
                            Expanded(
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                  Obx(() {
                                    return Text(logic.deviceName.value,
                                        style: GoogleFonts.roboto(
                                            color: ColorUtil.color_333333,
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w600));
                                  }),
                                  SizedBox(height: 11.h),
                                  Text(
                                      logic.currentIndex.value > -1
                                          ? "${DateUtil.getDateStrByMs(logic.list[logic.currentIndex.value].updateTime)}"
                                          : "刚刚",
                                      style: GoogleFonts.roboto(color: ColorUtil.color_999999, fontSize: 13.sp))
                                ]))
                          ])
                        ])),
                    Container(
                        margin: EdgeInsets.only(top: 11.h, left: 22.w, right: 22.w, bottom: 11.h),
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 22.h),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(11.r)),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text("其他设备",
                              style: GoogleFonts.roboto(
                                  color: ColorUtil.color_333333, fontSize: 18.sp, fontWeight: FontWeight.w600)),
                          ListView.separated(
                              padding: EdgeInsets.zero,
                              itemBuilder: (_, index) {
                                return Container(
                                    padding: EdgeInsets.symmetric(vertical: 11.h),
                                    child: Row(children: [
                                      Image.asset("assets/images/device.webp", width: 66.r, height: 66.r),
                                      SizedBox(width: 13.w),
                                      Expanded(
                                          child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                            Text("${logic.list[index].deviceName}",
                                                style: GoogleFonts.roboto(
                                                    color: ColorUtil.color_333333,
                                                    fontSize: 18.sp,
                                                    fontWeight: FontWeight.w600)),
                                            SizedBox(height: 11.h),
                                            Text("${DateUtil.getDateStrByMs(logic.list[index].updateTime)}",
                                                style:
                                                    GoogleFonts.roboto(color: ColorUtil.color_999999, fontSize: 13.sp))
                                          ]))
                                    ]));
                              },
                              separatorBuilder: (_, index) {
                                return const Divider(height: 0);
                              },
                              itemCount: logic.list.length,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true)
                        ]))
                  ]),
                );
              }))
    ]);
  }
}
