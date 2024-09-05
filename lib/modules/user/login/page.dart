import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vura/global/icon_font.dart';
import 'package:vura/route/route_path.dart';
import 'package:vura/utils/color_util.dart';
import 'package:vura/widgets/custom_icon_button.dart';
import 'package:vura/widgets/radius_inkwell_widget.dart';

import 'logic.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  LoginLogic get logic => Get.find<LoginLogic>();

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
          resizeToAvoidBottomInset: false,
          body: Hero(tag: "bg", child: Image.asset("assets/images/register_bg.webp", fit: BoxFit.cover))),
      Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 22.w),
              child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                SizedBox(height: 135.h),
                Hero(
                    tag: "hello",
                    child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text("HELLO,\n欢迎登陆",
                            style: GoogleFonts.roboto(
                                decoration: TextDecoration.none,
                                fontSize: 26.sp,
                                fontWeight: FontWeight.bold,
                                color: ColorUtil.color_333333),
                            textAlign: TextAlign.start))),
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
                            hintText: "请输入登录账号",
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
                      Expanded(child: Obx(() {
                        return TextField(
                            controller: logic.passwordController,
                            maxLines: 1,
                            obscureText: logic.obscureText.value,
                            style: GoogleFonts.roboto(fontSize: 13.sp, color: ColorUtil.color_333333),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 18.w),
                                hintText: "请输入登录密码",
                                hintStyle: GoogleFonts.roboto(fontSize: 13.sp, color: ColorUtil.color_999999)));
                      })),
                      CustomIconButton(
                          icon: Obx(() {
                            return Icon(logic.obscureText.value ? IconFont.eye_close_line : IconFont.eye_open_line,
                                color: ColorUtil.color_333333);
                          }),
                          onPressed: logic.obscureText.toggle,
                          radius: 18.r),
                      SizedBox(width: 10.w)
                    ])),
                Row(children: [
                  RichText(
                      text: TextSpan(children: [
                    const TextSpan(text: "没有账号？"),
                    TextSpan(
                        text: "立即注册",
                        style: const TextStyle(color: Color(0xff2ECC72)),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.toNamed(RoutePath.REGISTER_PAGE);
                          })
                  ], style: GoogleFonts.roboto(fontSize: 13.sp, color: ColorUtil.color_999999))),
                  const Spacer(),
                  GestureDetector(
                      onTap: () {
                        Get.toNamed(RoutePath.SET_PASSWORD_PAGE);
                      },
                      behavior: HitTestBehavior.translucent,
                      child: Text("忘记密码", style: GoogleFonts.roboto(fontSize: 13.sp, color: ColorUtil.color_999999)))
                ]),
                Hero(
                    tag: "submit_button",
                    child: RadiusInkWellWidget(
                        onPressed: () => logic.login(context),
                        radius: 44,
                        margin: EdgeInsets.only(top: 47.h),
                        child: Container(
                            width: 180.w,
                            height: 44.h,
                            alignment: Alignment.center,
                            child: Text("登录",
                                style: GoogleFonts.roboto(
                                    color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18.sp)))))
              ])))
    ]);
  }
}
