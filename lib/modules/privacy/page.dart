import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:im/global/enum.dart';
import 'package:im/modules/root/logic.dart';
import 'package:im/route/route_path.dart';
import 'package:im/utils/color_util.dart';
import 'package:im/widgets/radius_inkwell_widget.dart';

import 'logic.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  PrivacyLogic get logic => Get.find<PrivacyLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("隐私设置"), centerTitle: true),
        body: SingleChildScrollView(
          child: Column(children: [
            Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(11.r), color: Colors.white),
                margin: EdgeInsets.symmetric(horizontal: 22.w, vertical: 11.h),
                child: Column(children: [
                  RadiusInkWellWidget(
                      color: Colors.transparent,
                      onPressed: () {},
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(11.r), topRight: Radius.circular(11.r)),
                      child: Container(
                          height: 60.h,
                          padding: EdgeInsets.only(left: 22.w, right: 10.w),
                          child: Row(children: [
                            Text("登录账号", style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_333333)),
                            const Spacer(),
                            Obx(() {
                              return Text("${Get.find<RootLogic>().user.value?.userName}",
                                  style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_999999));
                            }),
                            const Icon(Icons.keyboard_arrow_right, color: ColorUtil.color_999999)
                          ]))),
                  Divider(height: 0, indent: 22.w, endIndent: 22.w),
                  RadiusInkWellWidget(
                      color: Colors.transparent,
                      borderRadius:
                          BorderRadius.only(bottomLeft: Radius.circular(11.r), bottomRight: Radius.circular(11.r)),
                      onPressed: () {
                        Get.toNamed(RoutePath.UPDATE_PASSWORD_PAGE);
                      },
                      child: Container(
                          height: 60.h,
                          padding: EdgeInsets.only(left: 22.w, right: 10.w),
                          child: Row(children: [
                            Text("登录密码", style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_333333)),
                            const Spacer(),
                            Text("修改登录密码", style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_999999)),
                            const Icon(Icons.keyboard_arrow_right, color: ColorUtil.color_999999)
                          ])))
                ])),
            Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(11.r), color: Colors.white),
                margin: EdgeInsets.symmetric(horizontal: 22.w),
                child: Column(children: [
                  RadiusInkWellWidget(
                      color: Colors.transparent,
                      onPressed: () {},
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(11.r), topRight: Radius.circular(11.r)),
                      child: Container(
                          height: 60.h,
                          padding: EdgeInsets.only(left: 22.w, right: 10.w),
                          child: Row(children: [
                            Text("支付密码", style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_333333)),
                            const Spacer(),
                            Text("设置支付密码", style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_999999)),
                            const Icon(Icons.keyboard_arrow_right, color: ColorUtil.color_999999)
                          ]))),
                  Divider(height: 0, indent: 22.w, endIndent: 22.w),
                  RadiusInkWellWidget(
                      color: Colors.transparent,
                      borderRadius:
                          BorderRadius.only(bottomLeft: Radius.circular(11.r), bottomRight: Radius.circular(11.r)),
                      onPressed: () {
                        Get.toNamed(RoutePath.GOOGLE_VERIFY_PAGE);
                      },
                      child: Container(
                          height: 60.h,
                          padding: EdgeInsets.only(left: 22.w, right: 10.w),
                          child: Row(children: [
                            Text("谷歌验证", style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_333333)),
                            const Spacer(),
                            Text("前往绑定", style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_999999)),
                            const Icon(Icons.keyboard_arrow_right, color: ColorUtil.color_999999)
                          ])))
                ])),
            Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(11.r), color: Colors.white),
                margin: EdgeInsets.symmetric(horizontal: 22.w, vertical: 11.h),
                child: Column(children: [
                  RadiusInkWellWidget(
                      color: Colors.transparent,
                      onPressed: () {},
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(11.r), topRight: Radius.circular(11.r)),
                      child: Container(
                          height: 60.h,
                          padding: EdgeInsets.only(left: 22.w, right: 10.w),
                          child: Row(children: [
                            Text("锁屏密码", style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_333333)),
                            const Spacer(),
                            Text("前往设置", style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_999999)),
                            const Icon(Icons.keyboard_arrow_right, color: ColorUtil.color_999999)
                          ]))),
                  Divider(height: 0, indent: 22.w, endIndent: 22.w),
                  Container(
                      height: 60.h,
                      padding: EdgeInsets.only(left: 22.w, right: 15.w),
                      child: Row(children: [
                        Text("登录保护", style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_333333)),
                        const Spacer(),
                        Obx(() {
                          return CupertinoSwitch(
                              value: Get.find<RootLogic>().user.value?.protect == YorNType.Y,
                              onChanged: logic.setProtect);
                        })
                      ])),
                  Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 22.w, right: 22.w, bottom: 20.h),
                      child: Text("开启登陆保护后，每次登录都会需要安全校验，推荐开启，保障您的安全",
                          style: GoogleFonts.roboto(fontSize: 13.sp, color: ColorUtil.color_999999)))
                ])),
            Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(11.r), color: Colors.white),
                margin: EdgeInsets.symmetric(horizontal: 22.w),
                child: Column(children: [
                  Container(
                      height: 60.h,
                      padding: EdgeInsets.only(left: 22.w, right: 15.w),
                      child: Row(children: [
                        Text("允许通过vura号搜索我", style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_333333)),
                        const Spacer(),
                        Obx(() {
                          return CupertinoSwitch(
                              value: Get.find<RootLogic>().user.value?.vura == YorNType.Y, onChanged: logic.setVura);
                        })
                      ])),
                  Divider(height: 0, indent: 22.w, endIndent: 22.w),
                  Container(
                      height: 60.h,
                      padding: EdgeInsets.only(left: 22.w, right: 15.w),
                      child: Row(children: [
                        Text("允许通过登录账号搜索我", style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_333333)),
                        const Spacer(),
                        Obx(() {
                          return CupertinoSwitch(
                              value: Get.find<RootLogic>().user.value?.search == YorNType.Y,
                              onChanged: logic.setSearch);
                        })
                      ])),
                  Divider(height: 0, indent: 22.w, endIndent: 22.w),
                  Container(
                      height: 60.h,
                      padding: EdgeInsets.only(left: 22.w, right: 15.w),
                      child: Row(children: [
                        Text("允许被添加好友功能", style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_333333)),
                        const Spacer(),
                        Obx(() {
                          return CupertinoSwitch(
                              value: Get.find<RootLogic>().user.value?.addFriend == YorNType.Y,
                              onChanged: logic.setAddFriend);
                        })
                      ])),
                  Divider(height: 0, indent: 22.w, endIndent: 22.w),
                  Container(
                      height: 60.h,
                      padding: EdgeInsets.only(left: 22.w, right: 15.w),
                      child: Row(children: [
                        Text("是否开启群聊功能", style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_333333)),
                        const Spacer(),
                        Obx(() {
                          return CupertinoSwitch(
                              value: Get.find<RootLogic>().user.value?.setGroup == YorNType.Y,
                              onChanged: logic.setSetGroup);
                        })
                      ])),
                  Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 22.w, right: 22.w, bottom: 20.h),
                      child:
                          Text("关闭后无法加入群聊", style: GoogleFonts.roboto(fontSize: 13.sp, color: ColorUtil.color_999999)))
                ]))
          ]),
        ));
  }
}
