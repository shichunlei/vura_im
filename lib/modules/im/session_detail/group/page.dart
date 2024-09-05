import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vura/entities/member_entity.dart';
import 'package:vura/entities/user_entity.dart';
import 'package:vura/global/enum.dart';
import 'package:vura/global/icon_font.dart';
import 'package:vura/global/keys.dart';
import 'package:vura/modules/im/widgets/item_session_user.dart';
import 'package:vura/route/route_path.dart';
import 'package:vura/utils/color_util.dart';
import 'package:vura/utils/dialog_util.dart';
import 'package:vura/utils/string_util.dart';
import 'package:vura/utils/tool_util.dart';
import 'package:vura/widgets/widgets.dart';

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
                padding: EdgeInsets.zero,
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
                              return Obx(() => index == logic.members.length &&
                                      (logic.bean.value!.isAdmin == YorNType.Y ||
                                          logic.bean.value!.isSupAdmin == YorNType.Y)
                                  ? Column(mainAxisSize: MainAxisSize.min, children: [
                                      AspectRatio(
                                          aspectRatio: 1,
                                          child: RadiusInkWellWidget(
                                              color: Colors.transparent,
                                              onPressed: () {
                                                Get.toNamed(RoutePath.SESSION_MEMBERS_PAGE, arguments: {
                                                  Keys.ID: logic.id,
                                                  Keys.TITLE: "移除人员",
                                                  "selectType": SelectType.checkbox,
                                                  "includeMe": false
                                                })?.then((value) {
                                                  if (value != null) {
                                                    show(builder: (_) {
                                                      return CustomAlertDialog(
                                                          title: "提示",
                                                          content:
                                                              "您确认要将${(value as List<MemberEntity>).map((item) => item.showNickName).toList().join(",")}从该群移除吗？",
                                                          confirmText: "移除",
                                                          onConfirm: () {
                                                            logic.deleteMembers(value);
                                                          });
                                                    });
                                                  }
                                                });
                                              },
                                              radius: 5.r,
                                              border: Border.all(color: const Color(0xfff5f5f5), width: 1),
                                              child: Container(
                                                  alignment: Alignment.center,
                                                  child: Icon(IconFont.minus,
                                                      size: 26.r, color: const Color(0xffdddddd))))),
                                      SizedBox(height: 10.h),
                                      Text("移除",
                                          style: GoogleFonts.roboto(fontSize: 11.sp, color: ColorUtil.color_999999))
                                    ])
                                  : index ==
                                          logic.members.length +
                                              (logic.bean.value!.isAdmin == YorNType.Y ||
                                                      logic.bean.value!.isSupAdmin == YorNType.Y
                                                  ? 1
                                                  : 0)
                                      ? Column(mainAxisSize: MainAxisSize.min, children: [
                                          AspectRatio(
                                              aspectRatio: 1,
                                              child: RadiusInkWellWidget(
                                                  color: Colors.transparent,
                                                  onPressed: () {
                                                    Get.toNamed(RoutePath.SELECT_CONTACTS_PAGE, arguments: {
                                                      "selectUserIds":
                                                          logic.members.map((item) => item.userId).toList(),
                                                      "isCheckBox": true
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
                                                      child: Icon(IconFont.add,
                                                          size: 26.r, color: const Color(0xffdddddd))))),
                                          SizedBox(height: 10.h),
                                          Text("邀请",
                                              style: GoogleFonts.roboto(fontSize: 11.sp, color: ColorUtil.color_999999))
                                        ])
                                      : ItemSessionUser(
                                          member: logic.members[index],
                                          groupId: logic.id,
                                          addFriend: logic.bean.value?.configObj?.addFriend == YorNType.N,
                                          isAdmin: logic.bean.value?.isAdmin == YorNType.Y));
                            },
                            itemCount: min(
                                10,
                                logic.members.length +
                                    (logic.bean.value!.isAdmin == YorNType.Y ||
                                            logic.bean.value!.isSupAdmin == YorNType.Y
                                        ? 2
                                        : 1)),
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true),
                        Visibility(
                            visible: logic.members.length > 10,
                            child: GestureDetector(
                                onTap: () {
                                  Get.toNamed(RoutePath.SESSION_MEMBERS_PAGE,
                                      arguments: {Keys.ID: logic.id, Keys.TITLE: "群成员"});
                                },
                                behavior: HitTestBehavior.translucent,
                                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                  Text("查看更多群成员",
                                      style: GoogleFonts.roboto(fontSize: 11.sp, color: ColorUtil.color_999999)),
                                  const Icon(Icons.keyboard_arrow_right, color: ColorUtil.color_999999)
                                ])))
                      ])),
                  logic.bean.value!.isAdmin == YorNType.Y
                      ? RadiusInkWellWidget(
                          onPressed: () {
                            Get.toNamed(RoutePath.SESSION_MANAGER_PAGE, arguments: {Keys.ID: logic.id});
                          },
                          radius: 11.r,
                          color: Colors.white,
                          margin: EdgeInsets.only(left: 22.w, right: 22.w, bottom: 11.h),
                          child: Container(
                              padding: EdgeInsets.only(left: 22.w, right: 10.w),
                              height: 60.h,
                              child: Row(children: [
                                Text("群管理", style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_333333)),
                                const Spacer(),
                                const Icon(Icons.keyboard_arrow_right, color: ColorUtil.color_999999)
                              ])))
                      : const SizedBox(),
                  Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(11.r), color: Colors.white),
                      margin: EdgeInsets.only(left: 22.w, right: 22.w, bottom: 11.h),
                      child: Column(children: [
                        RadiusInkWellWidget(
                            color: Colors.transparent,
                            onPressed: () {
                              if (logic.bean.value!.isAdmin != YorNType.Y &&
                                  logic.bean.value!.isSupAdmin != YorNType.Y) {
                                show(builder: (_) {
                                  return const CustomTipDialog(title: "温馨提示", content: "仅群主和管理员可修改群名称");
                                });
                                return;
                              }
                              Get.dialog(UpdateTextDialog(title: "请输入群聊名称", value: logic.bean.value?.name ?? ""))
                                  .then((value) {
                                if (value != null) logic.updateName(value);
                              });
                            },
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
                            onPressed: () {
                              if (logic.bean.value!.isAdmin != YorNType.Y &&
                                  logic.bean.value!.isSupAdmin != YorNType.Y) {
                                show(builder: (_) {
                                  return const CustomTipDialog(title: "温馨提示", content: "仅群主和管理员可修改群头像");
                                });
                                return;
                              }
                              showImagePickerDialog(context).then((value) {
                                if (value != null) {
                                  pickerImage(value, cropImage: true).then((path) {
                                    if (path != null) logic.updateAvatar(path);
                                  });
                                }
                              });
                            },
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
                        Container(
                            height: 60.h,
                            padding: EdgeInsets.only(left: 22.w, right: 22.w),
                            child: Row(children: [
                              Text("群聊编号", style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_333333)),
                              const Spacer(),
                              Text("${logic.id}",
                                  style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_999999))
                            ])),
                        Divider(height: 0, indent: 22.w, endIndent: 22.w),
                        RadiusInkWellWidget(
                            color: Colors.transparent,
                            onPressed: () {
                              if (logic.bean.value!.isAdmin != YorNType.Y &&
                                  logic.bean.value!.isSupAdmin != YorNType.Y) {
                                show(builder: (_) {
                                  return const CustomTipDialog(title: "温馨提示", content: "仅群主和管理员可修改群公告");
                                });
                                return;
                              }
                              Get.dialog(UpdateTextDialog(
                                      title: "请输入群公告",
                                      value: logic.bean.value?.notice ?? "",
                                      maxLines: 20,
                                      minLines: 3))
                                  .then((value) {
                                if (value != null) logic.updateNotice(value);
                              });
                            },
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
                      margin: EdgeInsets.only(left: 22.w, bottom: 44.h, right: 22.w),
                      child: Column(children: [
                        logic.bean.value!.isAdmin == YorNType.Y
                            ? RadiusInkWellWidget(
                                color: Colors.transparent,
                                onPressed: () {
                                  Get.bottomSheet(BottomDialog(
                                      content: "解散群聊后，群成员和群主都将被移除群聊",
                                      confirmText: "解散",
                                      onConfirm: () {
                                        logic.deleteSession();
                                      }));
                                },
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
                                onPressed: () {
                                  Get.bottomSheet(BottomDialog(
                                      content: "即将退出群聊“${logic.bean.value?.name}”",
                                      confirmText: "退出群聊",
                                      onConfirm: () {
                                        logic.quitSession();
                                      }));
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
                            onPressed: () {
                              show(builder: (_) {
                                return CustomAlertDialog(
                                    title: "温馨提示", content: "您确定要清空该群聊的聊天记录吗？", onConfirm: logic.clearMessage);
                              });
                            },
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
