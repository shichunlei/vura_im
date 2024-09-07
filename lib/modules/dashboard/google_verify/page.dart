import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:timelines_plus/timelines_plus.dart';
import 'package:vura/global/icon_font.dart';
import 'package:vura/utils/color_util.dart';
import 'package:vura/utils/tool_util.dart';
import 'package:vura/widgets/widgets.dart';

import 'logic.dart';

class GoogleVerifyPage extends StatelessWidget {
  const GoogleVerifyPage({super.key});

  GoogleVerifyLogic get logic => Get.find<GoogleVerifyLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("谷歌验证绑定"), centerTitle: true),
        body: BaseWidget(
            logic: logic,
            builder: (logic) {
              return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 22.h),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    TimelineTheme(
                        data: TimelineThemeData(
                            direction: Axis.vertical,
                            color: Theme.of(context).primaryColor,
                            nodePosition: 0,
                            indicatorPosition: 0),
                        child: Timeline.tileBuilder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            builder: TimelineTileBuilder.connected(
                                connectorBuilder: (BuildContext context, int index, ConnectorType type) =>
                                    const DashedLineConnector(gap: 4, dash: 5, color: Color(0x4f2ECC72)),
                                indicatorBuilder: (_, index) {
                                  return Container(
                                      height: 26.r,
                                      width: 26.r,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(14.r),
                                          color: const Color(0xff2ECC72),
                                          border: Border.all(color: const Color(0x3f2ECC72), width: 2)),
                                      alignment: Alignment.center,
                                      child: Text("${index + 1}",
                                          style: GoogleFonts.roboto(
                                              fontSize: 13.sp, fontWeight: FontWeight.bold, color: Colors.white)));
                                },
                                contentsBuilder: (_, index) {
                                  if (index == 0) {
                                    return Container(
                                        padding: EdgeInsets.only(left: 13.w),
                                        child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("下载谷歌验证器APP",
                                                  textAlign: TextAlign.justify,
                                                  style: GoogleFonts.roboto(fontSize: 13.sp, color: Colors.black)),
                                              Container(
                                                  margin: EdgeInsets.symmetric(vertical: 22.h),
                                                  width: 44.w,
                                                  height: 44.w,
                                                  child: Icon(IconFont.google, size: 40.w)),
                                              Row(children: [
                                                RadiusInkWellWidget(
                                                    radius: 40,
                                                    child: Container(
                                                        height: 40.h,
                                                        width: 132.w,
                                                        alignment: Alignment.center,
                                                        child: Text("ios下载",
                                                            style: GoogleFonts.roboto(
                                                                color: Colors.white, fontSize: 13.sp))),
                                                    onPressed: () {}),
                                                RadiusInkWellWidget(
                                                    margin: EdgeInsets.only(left: 22.w),
                                                    radius: 40,
                                                    child: Container(
                                                        height: 40.h,
                                                        width: 132.w,
                                                        alignment: Alignment.center,
                                                        child: Text("android下载",
                                                            style: GoogleFonts.roboto(
                                                                color: Colors.white, fontSize: 13.sp))),
                                                    onPressed: () {})
                                              ]),
                                              SizedBox(height: 22.h)
                                            ]));
                                  }
                                  if (index == 1) {
                                    return Column(mainAxisSize: MainAxisSize.min, children: [
                                      Container(
                                          padding: EdgeInsets.only(left: 13.w),
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                              "添加该平台提供的谷歌身份验证密钥。打开谷歌身份验证器App，安卓手机点击【添加新账户】，苹果手机点击【+】，扫描二维码添加，如果无法扫描二维码，可以手动输入密钥。",
                                              textAlign: TextAlign.justify,
                                              style: GoogleFonts.roboto(fontSize: 13.sp, color: Colors.black))),
                                      Center(
                                          child: Container(
                                              margin: EdgeInsets.symmetric(vertical: 13.h),
                                              width: 88.w,
                                              height: 88.w,
                                              child: PrettyQrView.data(
                                                  errorCorrectLevel: QrErrorCorrectLevel.H, data: "1231231313"))),
                                      Text("密钥：",
                                          style: GoogleFonts.roboto(fontSize: 11.sp, color: ColorUtil.color_999999)),
                                      SizedBox(height: 13.h),
                                      Text("SUNE516YM2C7G4D77X6RYFCOLB5ZMUDA",
                                          style: GoogleFonts.roboto(
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.bold,
                                              color: ColorUtil.color_333333)),
                                      RadiusInkWellWidget(
                                          margin: EdgeInsets.only(bottom: 22.h, top: 17.h),
                                          radius: 40,
                                          child: Container(
                                              height: 40.h,
                                              width: 132.w,
                                              alignment: Alignment.center,
                                              child: Text("复制密钥",
                                                  style: GoogleFonts.roboto(color: Colors.white, fontSize: 13.sp))),
                                          onPressed: () {
                                            copyToClipboard("text"); // todo
                                          })
                                    ]);
                                  }
                                  if (index == 2) {
                                    return Column(mainAxisSize: MainAxisSize.min, children: [
                                      Container(
                                          padding: EdgeInsets.only(left: 13.w),
                                          margin: EdgeInsets.only(bottom: 22.h),
                                          alignment: Alignment.centerLeft,
                                          child: Text("下方输入框中输入谷歌验证码，以验证完成谷歌身份验证绑定。(绑定后将不可使用密保登录，只能使用谷歌验证码!)",
                                              textAlign: TextAlign.justify,
                                              style: GoogleFonts.roboto(fontSize: 13.sp, color: Colors.black))),
                                      Container(
                                          height: 50.h,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(6.r),
                                              border: Border.all(color: const Color(0xffe5e5e5))),
                                          margin: EdgeInsets.symmetric(horizontal: 22.w),
                                          child: TextField(
                                              style: GoogleFonts.roboto(fontSize: 13.sp, color: ColorUtil.color_333333),
                                              decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
                                                  border: InputBorder.none,
                                                  hintText: "请输入验证器APP提供的6位验证码",
                                                  hintStyle: GoogleFonts.roboto(
                                                      fontSize: 13.sp, color: ColorUtil.color_999999)))),
                                      RadiusInkWellWidget(
                                          margin: EdgeInsets.symmetric(vertical: 22.h),
                                          radius: 40,
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(width: 1, color: const Color(0xffe5e5e5)),
                                                  borderRadius: BorderRadius.circular(9.r)),
                                              height: 44.h,
                                              width: 180.w,
                                              alignment: Alignment.center,
                                              child: Text("完成绑定",
                                                  style: GoogleFonts.roboto(
                                                      color: Colors.white,
                                                      fontSize: 18.sp,
                                                      fontWeight: FontWeight.bold))),
                                          onPressed: () {})
                                    ]);
                                  }
                                  return const SizedBox();
                                },
                                itemCount: 3)))
                  ]));
            }));
  }
}
