import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vura/global/icon_font.dart';
import 'package:vura/utils/color_util.dart';
import 'package:vura/widgets/widgets.dart';

import 'logic.dart';

class AddWayPage extends StatelessWidget {
  const AddWayPage({super.key});

  AddWayLogic get logic => Get.find<AddWayLogic>();

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
          body: Column(children: [
            Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10.r), topRight: Radius.circular(10.r))),
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
                          child:
                              Text("K豆钱包", style: GoogleFonts.roboto(color: ColorUtil.color_999999, fontSize: 15.sp))))
                ])),
            const Divider(height: 0),
            Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 22.h, horizontal: 22.w),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.only(bottomLeft: Radius.circular(10.r), bottomRight: Radius.circular(10.r))),
                margin: EdgeInsets.only(left: 22.w, right: 22.w),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  RichText(
                      text: TextSpan(children: const [
                    TextSpan(text: "*", style: TextStyle(color: Color(0xffFF4255))),
                    TextSpan(text: "账户备注")
                  ], style: GoogleFonts.roboto(fontSize: 13.sp, color: ColorUtil.color_333333))),
                  Container(
                      margin: EdgeInsets.symmetric(vertical: 13.h),
                      padding: EdgeInsets.only(left: 22.w),
                      height: 50.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9.r),
                          border: Border.all(width: 1, color: const Color(0xfff5f5f5))),
                      child: Row(children: [
                        Icon(IconFont.account_edit, size: 18.sp),
                        Expanded(
                            child: TextField(
                                controller: logic.accountController,
                                style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_333333),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "请输入k豆钱包账户备注",
                                    contentPadding: EdgeInsets.symmetric(horizontal: 13.w),
                                    hintStyle: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_999999))))
                      ])),
                  Row(children: [
                    RichText(
                        text: TextSpan(children: const [
                      TextSpan(text: "*", style: TextStyle(color: Color(0xffFF4255))),
                      TextSpan(text: "收款地址")
                    ], style: GoogleFonts.roboto(fontSize: 13.sp, color: ColorUtil.color_333333))),
                    const Spacer(),
                    Text("如何获取收款地址", style: GoogleFonts.roboto(color: const Color(0xffFF4255), fontSize: 11.sp)),
                    SizedBox(width: 9.w),
                    Icon(IconFont.question_mark, color: const Color(0xffFF4255), size: 13.sp)
                  ]),
                  Container(
                      margin: EdgeInsets.symmetric(vertical: 13.h),
                      padding: EdgeInsets.only(left: 22.w),
                      height: 50.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9.r),
                          border: Border.all(width: 1, color: const Color(0xfff5f5f5))),
                      child: Row(children: [
                        Icon(IconFont.account_address, size: 18.sp),
                        Expanded(
                            child: TextField(
                                controller: logic.addressController,
                                style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_333333),
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 13.w),
                                    border: InputBorder.none,
                                    hintText: "请输入k豆钱包收款地址",
                                    hintStyle: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_999999))))
                      ])),
                  Center(
                      child: RadiusInkWellWidget(
                          border: Border.all(width: 1, color: Theme.of(context).primaryColor),
                          radius: 40,
                          onPressed: () {},
                          margin: EdgeInsets.only(top: 31.h),
                          child: Container(
                              height: 53.h,
                              width: 180.w,
                              alignment: Alignment.center,
                              child: Text("下一步",
                                  style: GoogleFonts.roboto(
                                      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.sp)))))
                ]))
          ]))
    ]);
  }
}
