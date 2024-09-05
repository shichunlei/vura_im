import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vura/global/icon_font.dart';
import 'package:vura/utils/color_util.dart';
import 'package:vura/utils/device_utils.dart';
import 'package:vura/widgets/custom_icon_button.dart';
import 'package:vura/widgets/radius_inkwell_widget.dart';

import 'logic.dart';

class UpdatePasswordPage extends StatelessWidget {
  const UpdatePasswordPage({super.key});

  UpdatePasswordLogic get logic => Get.find<UpdatePasswordLogic>();

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
                        child: Text("HELLO,\n修改登录密码",
                            style: GoogleFonts.roboto(
                                decoration: TextDecoration.none,
                                fontSize: 26.sp,
                                fontWeight: FontWeight.bold,
                                color: ColorUtil.color_333333),
                            textAlign: TextAlign.start))),
                SizedBox(height: 22.h),
                Container(
                    alignment: Alignment.centerLeft,
                    child: Text("原始密码：",
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
                            controller: logic.oldPasswordController,
                            maxLines: 1,
                            obscureText: logic.obscureText.value,
                            style: GoogleFonts.roboto(fontSize: 13.sp, color: ColorUtil.color_333333),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 18.w),
                                hintText: "请输入原始密码",
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
                Container(
                    alignment: Alignment.centerLeft,
                    child: Text("新密码：",
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
                            obscureText: logic.newObscureText.value,
                            style: GoogleFonts.roboto(fontSize: 13.sp, color: ColorUtil.color_333333),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 18.w),
                                hintText: "请输入新密码",
                                hintStyle: GoogleFonts.roboto(fontSize: 13.sp, color: ColorUtil.color_999999)));
                      })),
                      CustomIconButton(
                          icon: Obx(() {
                            return Icon(logic.newObscureText.value ? IconFont.eye_close_line : IconFont.eye_open_line,
                                color: ColorUtil.color_333333);
                          }),
                          onPressed: logic.newObscureText.toggle,
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
                      Expanded(child: Obx(() {
                        return TextField(
                            controller: logic.rePasswordController,
                            maxLines: 1,
                            obscureText: logic.reObscureText.value,
                            style: GoogleFonts.roboto(fontSize: 13.sp, color: ColorUtil.color_333333),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 18.w),
                                hintText: "请再次输入密码",
                                hintStyle: GoogleFonts.roboto(fontSize: 13.sp, color: ColorUtil.color_999999)));
                      })),
                      CustomIconButton(
                          icon: Obx(() {
                            return Icon(logic.reObscureText.value ? IconFont.eye_close_line : IconFont.eye_open_line,
                                color: ColorUtil.color_333333);
                          }),
                          onPressed: logic.reObscureText.toggle,
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
                        controller: logic.securityIssuesController,
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
                              controller: logic.codeController,
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
                      decoration: BoxDecoration(border: Border.all(width: .5, color: Theme.of(context).primaryColor)),
                      alignment: Alignment.centerLeft,
                      child: Obx(() {
                        return logic.base64Img.value != null
                            ? Image(
                                height: 50.h,
                                width: 124.w,
                                fit: BoxFit.fill,
                                image: MemoryImage(base64.decode("${logic.base64Img.value?.img}")))
                            : const SizedBox();
                      }))
                ]),
                GestureDetector(
                    onTap: logic.getAuthCode,
                    behavior: HitTestBehavior.translucent,
                    child: Container(
                        alignment: Alignment.centerRight,
                        child: Text("刷新验证码",
                            style: GoogleFonts.roboto(color: Theme.of(context).primaryColor, fontSize: 13.sp)))),
                Hero(
                    tag: "submit_button",
                    child: RadiusInkWellWidget(
                        onPressed: () => logic.updatePassword(context),
                        radius: 44,
                        margin: EdgeInsets.only(bottom: 40.h, top: 47.h),
                        child: Container(
                            width: 180.w,
                            height: 44.h,
                            alignment: Alignment.center,
                            child: Text("确认修改",
                                style: GoogleFonts.roboto(
                                    color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18.sp)))))
              ]))),
      Positioned(top: DeviceUtils.topSafeHeight, left: 0, child: const BackButton())
    ]);
  }
}
