import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:im/global/icon_font.dart';
import 'package:im/utils/color_util.dart';
import 'package:im/utils/device_utils.dart';
import 'package:im/widgets/widgets.dart';

import 'logic.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  RegisterLogic get logic => Get.find<RegisterLogic>();

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(resizeToAvoidBottomInset: false, body: Image.asset("assets/images/register_bg.png", fit: BoxFit.cover)),
      Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 22.w),
              child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                SizedBox(height: 135.h),
                Container(
                    alignment: Alignment.centerLeft,
                    child: Text("HELLO,\n注册账号",
                        style: GoogleFonts.roboto(
                            fontSize: 26.sp, fontWeight: FontWeight.bold, color: ColorUtil.color_333333),
                        textAlign: TextAlign.start)),
                SizedBox(height: 22.h),
                Container(
                    alignment: Alignment.centerLeft,
                    child: Text("账号：",
                        style: GoogleFonts.roboto(
                            fontSize: 13.sp, fontWeight: FontWeight.w500, color: ColorUtil.color_333333))),
                Container(
                    margin: EdgeInsets.only(top: 13.h, bottom: 22.h),
                    height: 50.h,
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9.r), border: Border.all(color: const Color(0xffe5e5e5))),
                    child: TextField(
                        controller: logic.accountController,
                        maxLines: 1,
                        style: GoogleFonts.roboto(fontSize: 13.sp, color: ColorUtil.color_333333),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 18.w),
                            hintText: "请输入账号",
                            hintStyle: GoogleFonts.roboto(fontSize: 13.sp, color: ColorUtil.color_999999)))),
                Container(
                    alignment: Alignment.centerLeft,
                    child: Text("昵称：",
                        style: GoogleFonts.roboto(
                            fontSize: 13.sp, fontWeight: FontWeight.w500, color: ColorUtil.color_333333))),
                Container(
                    margin: EdgeInsets.only(top: 13.h, bottom: 22.h),
                    height: 50.h,
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9.r), border: Border.all(color: const Color(0xffe5e5e5))),
                    child: TextField(
                        controller: logic.nicknameController,
                        maxLines: 1,
                        style: GoogleFonts.roboto(fontSize: 13.sp, color: ColorUtil.color_333333),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 18.w),
                            hintText: "请输入昵称",
                            hintStyle: GoogleFonts.roboto(fontSize: 13.sp, color: ColorUtil.color_999999)))),
                Container(
                    alignment: Alignment.centerLeft,
                    child: Text("密码：",
                        style: GoogleFonts.roboto(
                            fontSize: 13.sp, fontWeight: FontWeight.w500, color: ColorUtil.color_333333))),
                Container(
                    margin: EdgeInsets.only(top: 13.h, bottom: 22.h),
                    height: 50.h,
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9.r), border: Border.all(color: const Color(0xffe5e5e5))),
                    child: Row(children: [
                      Expanded(
                          child: TextField(
                              controller: logic.passwordController,
                              maxLines: 1,
                              obscureText: true,
                              style: GoogleFonts.roboto(fontSize: 13.sp, color: ColorUtil.color_333333),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 18.w),
                                  hintText: "请输入密码",
                                  hintStyle: GoogleFonts.roboto(fontSize: 13.sp, color: ColorUtil.color_999999)))),
                      CustomIconButton(
                          icon: const Icon(IconFont.eye_close_line, color: ColorUtil.color_333333),
                          onPressed: () {},
                          radius: 18.r),
                      SizedBox(width: 10.w)
                    ])),
                Container(
                    alignment: Alignment.centerLeft,
                    child: Text("确认密码：",
                        style: GoogleFonts.roboto(
                            fontSize: 13.sp, fontWeight: FontWeight.w500, color: ColorUtil.color_333333))),
                Container(
                    margin: EdgeInsets.only(top: 13.h, bottom: 22.h),
                    height: 50.h,
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9.r), border: Border.all(color: const Color(0xffe5e5e5))),
                    child: Row(children: [
                      Expanded(
                          child: TextField(
                              controller: logic.rePasswordController,
                              maxLines: 1,
                              obscureText: true,
                              style: GoogleFonts.roboto(fontSize: 13.sp, color: ColorUtil.color_333333),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 18.w),
                                  hintText: "请再次输入密码",
                                  hintStyle: GoogleFonts.roboto(fontSize: 13.sp, color: ColorUtil.color_999999)))),
                      CustomIconButton(
                          icon: const Icon(IconFont.eye_open_line, color: ColorUtil.color_333333),
                          onPressed: () {},
                          radius: 18.r),
                      SizedBox(width: 10.w)
                    ])),
                Container(
                    alignment: Alignment.centerLeft,
                    child: Text("密保问题:您的初恋是谁？",
                        style: GoogleFonts.roboto(
                            fontSize: 13.sp, fontWeight: FontWeight.w500, color: ColorUtil.color_333333))),
                Container(
                    margin: EdgeInsets.only(top: 13.h, bottom: 22.h),
                    height: 50.h,
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9.r), border: Border.all(color: const Color(0xffe5e5e5))),
                    child: TextField(
                        controller: logic.passwordController,
                        maxLines: 1,
                        style: GoogleFonts.roboto(fontSize: 13.sp, color: ColorUtil.color_333333),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 18.w),
                            hintText: "请输入密保答案",
                            hintStyle: GoogleFonts.roboto(fontSize: 13.sp, color: ColorUtil.color_999999)))),
                Container(
                    alignment: Alignment.centerLeft,
                    child: Text("验证码：",
                        style: GoogleFonts.roboto(
                            fontSize: 13.sp, fontWeight: FontWeight.w500, color: ColorUtil.color_333333))),
                Row(children: [
                  Expanded(
                      child: Container(
                          margin: EdgeInsets.only(top: 13.h, bottom: 22.h),
                          height: 50.h,
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9.r),
                              border: Border.all(color: const Color(0xffe5e5e5))),
                          child: TextField(
                              controller: logic.passwordController,
                              maxLines: 1,
                              style: GoogleFonts.roboto(fontSize: 13.sp, color: ColorUtil.color_333333),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 18.w),
                                  hintText: "请输入验证码",
                                  hintStyle: GoogleFonts.roboto(fontSize: 13.sp, color: ColorUtil.color_999999))))),
                  Container(
                      width: 124.w,
                      margin: EdgeInsets.only(top: 13.h, bottom: 22.h, left: 22.w),
                      height: 50.h,
                      alignment: Alignment.centerLeft,
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(9.r), color: const Color(0xffe5e5e5)))
                ]),
                GestureDetector(
                    onTap: () {},
                    behavior: HitTestBehavior.translucent,
                    child: Container(
                        alignment: Alignment.centerRight,
                        child: Text("刷新验证码",
                            style: GoogleFonts.roboto(color: Theme.of(context).primaryColor, fontSize: 13.sp)))),
                RadiusInkWellWidget(
                    onPressed: logic.register,
                    radius: 44,
                    margin: EdgeInsets.only(bottom: 40.h, top: 47.h),
                    child: Container(
                        width: 180.w,
                        height: 44.h,
                        alignment: Alignment.center,
                        child: Text("注册",
                            style:
                                GoogleFonts.roboto(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18.sp))))
              ]))),
      Positioned(top: DeviceUtils.topSafeHeight, left: 0, child: const BackButton())
    ]);
  }
}
