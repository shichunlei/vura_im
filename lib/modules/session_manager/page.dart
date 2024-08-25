import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:im/global/enum.dart';
import 'package:im/global/keys.dart';
import 'package:im/route/route_path.dart';
import 'package:im/utils/color_util.dart';
import 'package:im/widgets/obx_widget.dart';
import 'package:im/widgets/radius_inkwell_widget.dart';

import 'logic.dart';

class SessionManagerPage extends StatelessWidget {
  final String? tag;

  const SessionManagerPage({super.key, this.tag});

  SessionManagerLogic get logic => Get.find<SessionManagerLogic>(tag: tag);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("群管理"), centerTitle: true),
        body: BaseWidget(
            logic: logic,
            showEmpty: false,
            showError: false,
            builder: (logic) {
              return SingleChildScrollView(
                child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(11.r), color: Colors.white),
                      margin: EdgeInsets.symmetric(horizontal: 22.w, vertical: 11.h),
                      child: Column(children: [
                        Container(
                            height: 60.h,
                            padding: EdgeInsets.only(left: 22.w, right: 15.w),
                            child: Row(children: [
                              Text("群聊邀请确认", style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_333333)),
                              const Spacer(),
                              CupertinoSwitch(
                                  value: logic.bean.value?.invite == YorNType.Y, onChanged: logic.updateInviteConfig)
                            ])),
                        Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(left: 22.w, right: 22.w, bottom: 20.h),
                            child: Text("启用后，群成员需群主或群管理员确认才能邀请朋友进群，扫描二维码进群将同时停用",
                                style: GoogleFonts.roboto(fontSize: 13.sp, color: ColorUtil.color_999999)))
                      ])),
                  RadiusInkWellWidget(
                      padding: EdgeInsets.only(left: 22.w, right: 10.w),
                      onPressed: () {
                        Get.toNamed(RoutePath.SESSION_MEMBERS_PAGE, arguments: {Keys.ID: logic.id, Keys.TITLE: "转让群主"});
                      },
                      radius: 11.r,
                      color: Colors.white,
                      margin: EdgeInsets.symmetric(horizontal: 22.w),
                      child: SizedBox(
                          height: 60.h,
                          child: Row(children: [
                            Text("群主管理权转让", style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_333333)),
                            const Spacer(),
                            const Icon(Icons.keyboard_arrow_right, color: ColorUtil.color_999999)
                          ]))),
                  Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(top: 22.h, bottom: 11.h, left: 22.w),
                      child: Text("成员设置",
                          style: GoogleFonts.roboto(
                              fontSize: 13.sp, fontWeight: FontWeight.bold, color: ColorUtil.color_999999))),
                  Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(11.r), color: Colors.white),
                      margin: EdgeInsets.symmetric(horizontal: 22.w),
                      child: Column(children: [
                        Container(
                            height: 60.h,
                            padding: EdgeInsets.only(left: 22.w, right: 15.w),
                            child: Row(children: [
                              Text("全员禁言", style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_333333)),
                              const Spacer(),
                              CupertinoSwitch(
                                  value: logic.bean.value?.allMute == YorNType.Y, onChanged: logic.updateAllMuteConfig),
                            ])),
                        Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(left: 22.w, right: 22.w, bottom: 20.h),
                            child: Text("成员禁言启用后，只允许群主和管理员发言",
                                style: GoogleFonts.roboto(fontSize: 13.sp, color: ColorUtil.color_999999))),
                        const Divider(height: 0),
                        Container(
                            height: 60.h,
                            padding: EdgeInsets.only(left: 22.w, right: 15.w),
                            child: Row(children: [
                              Text("禁止群成员互加好友",
                                  style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_333333)),
                              const Spacer(),
                              CupertinoSwitch(
                                  value: logic.bean.value?.addFriend == YorNType.Y,
                                  onChanged: logic.updateAddFriendConfig),
                            ])),
                        Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(left: 22.w, right: 22.w, bottom: 20.h),
                            child: Text("开启后，群成员无法通过该群邀请好友以及查看其他用户信息",
                                style: GoogleFonts.roboto(fontSize: 13.sp, color: ColorUtil.color_999999))),
                        const Divider(height: 0),
                        Container(
                            height: 60.h,
                            padding: EdgeInsets.only(left: 22.w, right: 15.w),
                            child: Row(children: [
                              Text("群组全体禁止领取VURA",
                                  style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_333333)),
                              const Spacer(),
                              CupertinoSwitch(
                                  value: logic.bean.value?.vura == YorNType.Y, onChanged: logic.updateVuraConfig),
                            ])),
                        Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(left: 22.w, right: 22.w, bottom: 20.h),
                            child: Text("开启后，除管理员，群主之外，所有人禁止领取VURA",
                                style: GoogleFonts.roboto(fontSize: 13.sp, color: ColorUtil.color_999999))),
                      ])),
                  RadiusInkWellWidget(
                      padding: EdgeInsets.only(left: 22.w, right: 10.w),
                      onPressed: () {
                        Get.toNamed(RoutePath.MUTE_PAGE, arguments: {Keys.ID: logic.id});
                      },
                      radius: 11.r,
                      color: Colors.white,
                      margin: EdgeInsets.symmetric(horizontal: 22.w, vertical: 11.h),
                      child: SizedBox(
                          height: 60.h,
                          child: Row(children: [
                            Text("禁言列表", style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_333333)),
                            const Spacer(),
                            const Icon(Icons.keyboard_arrow_right, color: ColorUtil.color_999999)
                          ]))),
                  Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(top: 11.h, bottom: 11.h, left: 22.w),
                      child: Text("管理员设置",
                          style: GoogleFonts.roboto(
                              fontSize: 13.sp, fontWeight: FontWeight.bold, color: ColorUtil.color_999999))),
                  RadiusInkWellWidget(
                      padding: EdgeInsets.only(left: 22.w, right: 10.w),
                      onPressed: () {
                        Get.toNamed(RoutePath.SESSION_SUP_ADMIN_PAGE, arguments: {Keys.ID: logic.id});
                      },
                      radius: 11.r,
                      color: Colors.white,
                      margin: EdgeInsets.symmetric(horizontal: 22.w),
                      child: SizedBox(
                          height: 60.h,
                          child: Row(children: [
                            Text("添加管理员", style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_333333)),
                            const Spacer(),
                            const Icon(Icons.keyboard_arrow_right, color: ColorUtil.color_999999)
                          ])))
                ]),
              );
            }));
  }
}
