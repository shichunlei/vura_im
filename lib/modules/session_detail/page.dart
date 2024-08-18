import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:im/entities/member_entity.dart';
import 'package:im/entities/user_entity.dart';
import 'package:im/global/icon_font.dart';
import 'package:im/route/route_path.dart';
import 'package:im/utils/color_util.dart';
import 'package:im/utils/string_util.dart';
import 'package:im/widgets/obx_widget.dart';
import 'package:im/widgets/radius_inkwell_widget.dart';
import 'package:im/widgets/round_image.dart';

import 'logic.dart';

class SessionDetailPage extends StatelessWidget {
  final String? tag;

  const SessionDetailPage({super.key, this.tag});

  SessionDetailLogic get logic => Get.find<SessionDetailLogic>(tag: tag);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Obx(() {
              return Text(logic.bean.value?.name ?? "聊天信息");
            }),
            centerTitle: true),
        body: BaseWidget(
            logic: logic,
            builder: (logic) {
              return SingleChildScrollView(
                child: Column(children: [
                  /// 单聊
                  !logic.isGroup
                      ? Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(11.r), color: Colors.white),
                          margin: EdgeInsets.symmetric(horizontal: 22.w, vertical: 11.h),
                          padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 22.h),
                          child: Row(children: [
                            RoundImage("https://q2.itc.cn/q_70/images03/20240807/9efb7d3e616440c6ab1d7e1d9b9be14f.jpeg",
                                width: 53.r,
                                height: 53.r,
                                radius: 5.r,
                                onTap: () {},
                                errorImage: "assets/images/default_face.webp",
                                placeholderImage: "assets/images/default_face.webp"),
                            SizedBox(width: 13.w),
                            Expanded(
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                  Text("${logic.bean.value?.remarkNickName}",
                                      style: GoogleFonts.roboto(
                                          fontSize: 18.sp, color: Colors.black, fontWeight: FontWeight.w600)),
                                  SizedBox(height: 13.r),
                                  Text("23423423424",
                                      style: GoogleFonts.roboto(fontSize: 13.sp, color: ColorUtil.color_999999))
                                ]))
                          ]))
                      :

                      /// 群聊人员列表
                      Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(11.r), color: Colors.white),
                          margin: EdgeInsets.symmetric(horizontal: 22.w, vertical: 11.h),
                          child: GridView.builder(
                              padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 22.h),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 5,
                                  childAspectRatio: .65,
                                  crossAxisSpacing: 13.r,
                                  mainAxisSpacing: 13.r),
                              itemBuilder: (_, index) {
                                if (index == logic.members.length) {
                                  return Column(mainAxisSize: MainAxisSize.min, children: [
                                    AspectRatio(
                                        aspectRatio: 1,
                                        child: RadiusInkWellWidget(
                                            color: Colors.transparent,
                                            onPressed: () {
                                              Get.toNamed(RoutePath.SELECT_CONTACTS_PAGE);
                                            },
                                            radius: 5.r,
                                            border: Border.all(color: const Color(0xfff5f5f5), width: 1),
                                            child: Container(
                                                alignment: Alignment.center,
                                                child:
                                                    Icon(IconFont.minus, size: 26.r, color: const Color(0xffdddddd))))),
                                    SizedBox(height: 10.h),
                                    Text("移除",
                                        style: GoogleFonts.roboto(fontSize: 11.sp, color: ColorUtil.color_999999))
                                  ]);
                                }
                                if (index == logic.members.length + 1) {
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
                                                child:
                                                    Icon(IconFont.add, size: 26.r, color: const Color(0xffdddddd))))),
                                    SizedBox(height: 10.h),
                                    Text("邀请",
                                        style: GoogleFonts.roboto(fontSize: 11.sp, color: ColorUtil.color_999999))
                                  ]);
                                }

                                return ItemSessionUser(member: logic.members[index]);
                              },
                              itemCount: logic.members.length + 2,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true)),

                  Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(11.r), color: Colors.white),
                      margin: EdgeInsets.symmetric(horizontal: 22.w),
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
                                  Text("昵称", style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_333333)),
                                  const Spacer(),
                                  Text("${logic.bean.value?.showNickName}",
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
                                  Text("设置备注",
                                      style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_333333)),
                                  const Spacer(),
                                  Text(logic.bean.value?.remarkNickName ?? "前往设置",
                                      style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_999999)),
                                  const Icon(Icons.keyboard_arrow_right, color: ColorUtil.color_999999)
                                ]))),
                        Divider(height: 0, indent: 22.w, endIndent: 22.w),
                        Container(
                            height: 60.h,
                            padding: EdgeInsets.only(left: 22.w, right: 15.w),
                            child: Row(children: [
                              Text("置顶聊天", style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_333333)),
                              const Spacer(),
                              CupertinoSwitch(value: false, onChanged: (value) {}),
                            ])),
                        Divider(height: 0, indent: 22.w, endIndent: 22.w),
                        Container(
                            height: 60.h,
                            padding: EdgeInsets.only(left: 22.w, right: 15.w),
                            child: Row(children: [
                              Text("免打扰", style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_333333)),
                              const Spacer(),
                              CupertinoSwitch(value: false, onChanged: (value) {}),
                            ])),
                        Divider(height: 0, indent: 22.w, endIndent: 22.w),
                        Container(
                            height: 60.h,
                            padding: EdgeInsets.only(left: 22.w, right: 15.w),
                            child: Row(children: [
                              Text("加入黑名单", style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_333333)),
                              const Spacer(),
                              CupertinoSwitch(value: false, onChanged: (value) {}),
                            ]))
                      ])),
                  Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(11.r), color: Colors.white),
                      margin: EdgeInsets.symmetric(horizontal: 22.w, vertical: 11.h),
                      child: Column(children: [
                        RadiusInkWellWidget(
                            color: Colors.transparent,
                            onPressed: () {
                              logic.quitSession();
                            },
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
          child: RoundImage("${member.headImage}",
              width: double.infinity,
              height: double.infinity,
              radius: 5.r,
              onTap: () {},
              errorImage: "assets/images/default_face.webp",
              placeholderImage: "assets/images/default_face.webp")),
      SizedBox(height: 10.h),
      Text("${StringUtil.isNotEmpty(member.remarkNickName) ? member.remarkNickName : member.showNickName}",
          style: GoogleFonts.roboto(fontSize: 11.sp, color: ColorUtil.color_999999),
          maxLines: 1,
          overflow: TextOverflow.ellipsis)
    ]);
  }
}
