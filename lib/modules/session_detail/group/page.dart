import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:im/entities/member_entity.dart';
import 'package:im/entities/user_entity.dart';
import 'package:im/global/enum.dart';
import 'package:im/global/icon_font.dart';
import 'package:im/global/keys.dart';
import 'package:im/modules/root/logic.dart';
import 'package:im/route/route_path.dart';
import 'package:im/utils/color_util.dart';
import 'package:im/utils/string_util.dart';
import 'package:im/widgets/obx_widget.dart';
import 'package:im/widgets/radius_inkwell_widget.dart';
import 'package:im/widgets/round_image.dart';

import 'logic.dart';

class GroupSessionDetailPage extends StatelessWidget {
  final String? tag;

  const GroupSessionDetailPage({super.key, this.tag});

  GroupSessionDetailLogic get logic => Get.find<GroupSessionDetailLogic>(tag: tag);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("聊天信息"), centerTitle: true),
        body: BaseWidget(
            logic: logic,
            builder: (logic) {
              return SingleChildScrollView(
                child: Column(children: [
                  Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(11.r), color: Colors.white),
                      margin: EdgeInsets.symmetric(horizontal: 22.w, vertical: 11.h),
                      child: Column(children: [
                        GridView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 22.h),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 5,
                                childAspectRatio: .65,
                                crossAxisSpacing: 13.r,
                                mainAxisSpacing: 13.r),
                            itemBuilder: (_, index) {
                              if (index == logic.members.length &&
                                  logic.bean.value?.ownerId == Get.find<RootLogic>().user.value?.id) {
                                return Column(mainAxisSize: MainAxisSize.min, children: [
                                  AspectRatio(
                                      aspectRatio: 1,
                                      child: RadiusInkWellWidget(
                                          color: Colors.transparent,
                                          onPressed: () {
                                            Get.toNamed(RoutePath.SESSION_MEMBERS_PAGE, arguments: {Keys.ID: logic.id});
                                          },
                                          radius: 5.r,
                                          border: Border.all(color: const Color(0xfff5f5f5), width: 1),
                                          child: Container(
                                              alignment: Alignment.center,
                                              child:
                                                  Icon(IconFont.minus, size: 26.r, color: const Color(0xffdddddd))))),
                                  SizedBox(height: 10.h),
                                  Text("移除", style: GoogleFonts.roboto(fontSize: 11.sp, color: ColorUtil.color_999999))
                                ]);
                              }
                              if (index ==
                                  logic.members.length +
                                      (logic.bean.value?.ownerId == Get.find<RootLogic>().user.value?.id ? 1 : 0)) {
                                return Column(mainAxisSize: MainAxisSize.min, children: [
                                  AspectRatio(
                                      aspectRatio: 1,
                                      child: RadiusInkWellWidget(
                                          color: Colors.transparent,
                                          onPressed: () {
                                            Get.toNamed(RoutePath.SELECT_CONTACTS_PAGE, arguments: {
                                              "selectUserIds": logic.members.map((item) => item.userId).toList()
                                            })?.then((value) {
                                              if (value != null && value is List<UserEntity>) {
                                                logic.inviteMembers(value);
                                              }
                                            });
                                          },
                                          radius: 5.r,
                                          border: Border.all(color: const Color(0xfff5f5f5), width: 1),
                                          child: Container(
                                              alignment: Alignment.center,
                                              child: Icon(IconFont.add, size: 26.r, color: const Color(0xffdddddd))))),
                                  SizedBox(height: 10.h),
                                  Text("邀请", style: GoogleFonts.roboto(fontSize: 11.sp, color: ColorUtil.color_999999))
                                ]);
                              }

                              return ItemSessionUser(member: logic.members[index]);
                            },
                            itemCount: min(
                                10,
                                logic.members.length +
                                    (logic.bean.value?.ownerId == Get.find<RootLogic>().user.value?.id ? 2 : 1)),
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true),
                        Visibility(
                            visible: logic.members.length > 10,
                            child: GestureDetector(
                                onTap: () {
                                  Get.toNamed(RoutePath.SESSION_MEMBERS_PAGE, arguments: {Keys.ID: logic.id});
                                },
                                behavior: HitTestBehavior.translucent,
                                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                  Text("查看更多群成员",
                                      style: GoogleFonts.roboto(fontSize: 11.sp, color: ColorUtil.color_999999)),
                                  const Icon(Icons.keyboard_arrow_right, color: ColorUtil.color_999999)
                                ])))
                      ])),
                  RadiusInkWellWidget(
                      onPressed: () {
                        Get.toNamed(RoutePath.SESSION_MANAGER_PAGE, arguments: {Keys.ID: logic.id});
                      },
                      radius: 11.r,
                      color: Colors.white,
                      margin: EdgeInsets.symmetric(horizontal: 22.w),
                      child: Container(
                          padding: EdgeInsets.only(left: 22.w, right: 10.w),
                          height: 60.h,
                          child: Row(children: [
                            Text("群管理", style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_333333)),
                            const Spacer(),
                            const Icon(Icons.keyboard_arrow_right, color: ColorUtil.color_999999)
                          ]))),
                  Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(11.r), color: Colors.white),
                      margin: EdgeInsets.symmetric(horizontal: 22.w, vertical: 11.h),
                      child: Column(children: [
                        RadiusInkWellWidget(
                            color: Colors.transparent,
                            onPressed: () {},
                            borderRadius:
                                BorderRadius.only(topLeft: Radius.circular(11.r), topRight: Radius.circular(11.r)),
                            child: Container(
                                height: 60.h,
                                padding: EdgeInsets.only(left: 22.w, right: 22.w),
                                child: Row(children: [
                                  Text("群聊名称",
                                      style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_333333)),
                                  const Spacer(),
                                  Text("${logic.bean.value?.name}",
                                      style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_999999))
                                ]))),
                        Divider(height: 0, indent: 22.w, endIndent: 22.w),
                        RadiusInkWellWidget(
                            color: Colors.transparent,
                            onPressed: () {},
                            radius: 0,
                            child: Container(
                                height: 60.h,
                                padding: EdgeInsets.only(left: 22.w, right: 10.w),
                                child: Row(children: [
                                  Text("群聊头像",
                                      style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_333333)),
                                  const Spacer(),
                                  RoundImage("${logic.bean.value?.headImage}",
                                      height: 26.r,
                                      width: 26.r,
                                      radius: 2.r,
                                      errorImage: "assets/images/default_group_head.webp",
                                      placeholderImage: "assets/images/default_group_head.webp"),
                                  const Icon(Icons.keyboard_arrow_right, color: ColorUtil.color_999999)
                                ]))),
                        Divider(height: 0, indent: 22.w, endIndent: 22.w),
                        RadiusInkWellWidget(
                            color: Colors.transparent,
                            onPressed: () {},
                            radius: 0,
                            child: Container(
                                height: 60.h,
                                padding: EdgeInsets.only(left: 22.w, right: 10.w),
                                child: Row(children: [
                                  Text("群聊编号",
                                      style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_333333)),
                                  const Spacer(),
                                  Text("235353",
                                      style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_999999)),
                                  const Icon(Icons.keyboard_arrow_right, color: ColorUtil.color_999999)
                                ]))),
                        Divider(height: 0, indent: 22.w, endIndent: 22.w),
                        RadiusInkWellWidget(
                            color: Colors.transparent,
                            onPressed: () {},
                            radius: 0,
                            child: Container(
                                height: 60.h,
                                padding: EdgeInsets.only(left: 22.w, right: 10.w),
                                child: Row(children: [
                                  Text("群公告",
                                      style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_333333)),
                                  const Spacer(),
                                  const Icon(Icons.keyboard_arrow_right, color: ColorUtil.color_999999)
                                ]))),
                        Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(bottom: 11.h, left: 22.w, right: 22.w),
                            child: Text(
                                StringUtil.isEmpty(logic.bean.value?.notice) ? "未设置群公告" : "${logic.bean.value?.notice}",
                                style: GoogleFonts.roboto(color: ColorUtil.color_999999, fontSize: 14.sp))),
                        Divider(height: 0, indent: 22.w, endIndent: 22.w),
                        Container(
                            height: 60.h,
                            padding: EdgeInsets.only(left: 22.w, right: 15.w),
                            child: Row(children: [
                              Text("置顶聊天", style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_333333)),
                              const Spacer(),
                              CupertinoSwitch(value: logic.bean.value!.moveTop, onChanged: logic.setTop),
                            ])),
                        Divider(height: 0, indent: 22.w, endIndent: 22.w),
                        Container(
                            height: 60.h,
                            padding: EdgeInsets.only(left: 22.w, right: 15.w),
                            child: Row(children: [
                              Text("免打扰", style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_333333)),
                              const Spacer(),
                              CupertinoSwitch(value: logic.bean.value!.isDisturb, onChanged: logic.setDisturb),
                            ]))
                      ])),
                  Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(11.r), color: Colors.white),
                      margin: EdgeInsets.symmetric(horizontal: 22.w),
                      child: Column(children: [
                        logic.bean.value!.isAdmin
                            ? RadiusInkWellWidget(
                                color: Colors.transparent,
                                onPressed: logic.deleteSession,
                                borderRadius:
                                    BorderRadius.only(topLeft: Radius.circular(11.r), topRight: Radius.circular(11.r)),
                                child: Container(
                                    height: 60.h,
                                    padding: EdgeInsets.only(left: 22.w),
                                    alignment: Alignment.centerLeft,
                                    child: Text("解散群聊",
                                        style: GoogleFonts.roboto(fontSize: 15.sp, color: const Color(0xffDB5549)))))
                            : RadiusInkWellWidget(
                                color: Colors.transparent,
                                onPressed: logic.quitSession,
                                borderRadius:
                                    BorderRadius.only(topLeft: Radius.circular(11.r), topRight: Radius.circular(11.r)),
                                child: Container(
                                    height: 60.h,
                                    padding: EdgeInsets.only(left: 22.w),
                                    alignment: Alignment.centerLeft,
                                    child: Text("退出群聊",
                                        style: GoogleFonts.roboto(fontSize: 15.sp, color: const Color(0xffDB5549))))),
                        Divider(height: 0, indent: 22.w, endIndent: 22.w),
                        RadiusInkWellWidget(
                            margin: EdgeInsets.only(bottom: 40.h),
                            color: Colors.transparent,
                            onPressed: () {},
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(11.r), bottomLeft: Radius.circular(11.r)),
                            child: Container(
                                height: 60.h,
                                padding: EdgeInsets.only(left: 22.w),
                                alignment: Alignment.centerLeft,
                                child: Text("清空聊天记录",
                                    style: GoogleFonts.roboto(fontSize: 15.sp, color: const Color(0xffDB5549))))),
                      ]))
                ]),
              );
            }));
  }
}

class ItemSessionUser extends StatelessWidget {
  final MemberEntity member;

  const ItemSessionUser({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      AspectRatio(
          aspectRatio: 1,
          child: RoundImage("${member.headImage}", width: double.infinity, height: double.infinity, radius: 5.r,
              onTap: () {
            Get.toNamed(RoutePath.SESSION_MEMBER_PAGE, arguments: {Keys.ID: member.userId});
          },
              errorWidget: StringUtil.isNotEmpty(member.showNickName)
                  ? Container(
                      width: 53.r,
                      height: 53.r,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.r),
                          border: Border.all(color: Colors.white, width: 1),
                          color: ColorUtil.strToColor(member.showNickName!)),
                      alignment: Alignment.center,
                      child: FittedBox(
                          fit: BoxFit.contain,
                          child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text(member.showNickName![0],
                                  style: TextStyle(fontSize: 20.sp, color: Colors.white)))))
                  : Image.asset("assets/images/default_face.webp", width: 53.r, height: 53.r),
              placeholderImage: "assets/images/default_face.webp")),
      SizedBox(height: 10.h),
      Text("${member.showNickName}",
          style: GoogleFonts.roboto(fontSize: 11.sp, color: ColorUtil.color_999999),
          maxLines: 1,
          overflow: TextOverflow.ellipsis)
    ]);
  }
}
