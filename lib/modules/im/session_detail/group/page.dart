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
        appBar: AppBar(title: Text("Group Info".tr), centerTitle: true),
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
                              if (index ==
                                  min(
                                      logic.members.length,
                                      logic.bean.value?.isAdmin == YorNType.Y ||
                                              logic.bean.value?.isSupAdmin == YorNType.Y
                                          ? 8
                                          : 9)) {
                                return Column(mainAxisSize: MainAxisSize.min, children: [
                                  AspectRatio(
                                      aspectRatio: 1,
                                      child: RadiusInkWellWidget(
                                          color: Colors.transparent,
                                          onPressed: () {
                                            Get.toNamed(RoutePath.SELECT_CONTACTS_PAGE, arguments: {
                                              "selectUserIds": logic.members.map((item) => item.userId).toList(),
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
                                              child: Icon(IconFont.add, size: 26.r, color: const Color(0xffdddddd))))),
                                  SizedBox(height: 10.h),
                                  Text("invite".tr,
                                      style: GoogleFonts.roboto(fontSize: 11.sp, color: ColorUtil.color_999999))
                                ]);
                              }

                              if ((logic.bean.value?.isAdmin == YorNType.Y ||
                                      logic.bean.value?.isSupAdmin == YorNType.Y) &&
                                  index == min(logic.members.length, 8) + 1) {
                                return Column(mainAxisSize: MainAxisSize.min, children: [
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
                                              child:
                                                  Icon(IconFont.minus, size: 26.r, color: const Color(0xffdddddd))))),
                                  SizedBox(height: 10.h),
                                  Text("Remove".tr,
                                      style: GoogleFonts.roboto(fontSize: 11.sp, color: ColorUtil.color_999999))
                                ]);
                              }

                              return ItemSessionUser(member: logic.members[index], groupId: logic.id, tag: tag);
                            },
                            itemCount: min(
                                    logic.members.length,
                                    (logic.bean.value?.isAdmin == YorNType.Y ||
                                            logic.bean.value?.isSupAdmin == YorNType.Y
                                        ? 8
                                        : 9)) +
                                (logic.bean.value!.isAdmin == YorNType.Y || logic.bean.value!.isSupAdmin == YorNType.Y
                                    ? 2
                                    : 1),
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true),
                        Visibility(
                            visible: logic.members.length >
                                (logic.bean.value!.isAdmin == YorNType.Y || logic.bean.value!.isSupAdmin == YorNType.Y
                                    ? 8
                                    : 9),
                            child: GestureDetector(
                                onTap: () {
                                  Get.toNamed(RoutePath.SESSION_MEMBERS_PAGE, arguments: {
                                    Keys.ID: logic.id,
                                    Keys.TITLE: "群成员",
                                    "canViewMemberInfo": logic.bean.value?.configObj?.addFriend == YorNType.N
                                  });
                                },
                                behavior: HitTestBehavior.translucent,
                                child: Padding(
                                    padding: EdgeInsets.only(bottom: 11.h),
                                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                      Text("View More Members".tr,
                                          style: GoogleFonts.roboto(fontSize: 11.sp, color: ColorUtil.color_999999)),
                                      Icon(Icons.keyboard_arrow_right, color: ColorUtil.color_999999, size: 15.sp)
                                    ]))))
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
                                Text("Manage Group".tr,
                                    style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_333333)),
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
                                padding: EdgeInsets.only(left: 22.w, right: 11.w),
                                child: Row(children: [
                                  Text("Group Name".tr,
                                      style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_333333)),
                                  const Spacer(),
                                  Text("${logic.bean.value?.name}",
                                      style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_999999)),
                                  const Icon(Icons.keyboard_arrow_right, color: ColorUtil.color_999999)
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
                                  Text("Group Image".tr,
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
                            onPressed: () {
                              if (logic.bean.value!.isAdmin != YorNType.Y) {
                                show(builder: (_) {
                                  return const CustomTipDialog(title: "温馨提示", content: "仅群主可修改群编号");
                                });
                                return;
                              }
                              Get.dialog(UpdateTextDialog(title: "请输入群聊编号", value: logic.bean.value?.no ?? ""))
                                  .then((value) {
                                if (value != null) logic.updateNo(value);
                              });
                            },
                            radius: 0,
                            child: Container(
                                height: 60.h,
                                padding: EdgeInsets.only(left: 22.w, right: 11.w),
                                child: Row(children: [
                                  Text("Group NO".tr,
                                      style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_333333)),
                                  const Spacer(),
                                  Text("${logic.bean.value?.no}",
                                      style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_999999)),
                                  const Icon(Icons.keyboard_arrow_right, color: ColorUtil.color_999999)
                                ]))),
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
                                  Text("Group Notice".tr,
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
                              Text("Sticky on Top".tr,
                                  style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_333333)),
                              const Spacer(),
                              CupertinoSwitch(value: logic.bean.value!.moveTop, onChanged: logic.setTop),
                            ])),
                        Divider(height: 0, indent: 22.w, endIndent: 22.w),
                        Container(
                            height: 60.h,
                            padding: EdgeInsets.only(left: 22.w, right: 15.w),
                            child: Row(children: [
                              Text("Mute Notifications".tr,
                                  style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_333333)),
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
                                      content: "Disband Tip".tr,
                                      confirmText: "Disband".tr,
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
                                    child: Text("Disband Group".tr,
                                        style: GoogleFonts.roboto(fontSize: 15.sp, color: const Color(0xffDB5549)))))
                            : RadiusInkWellWidget(
                                color: Colors.transparent,
                                onPressed: () {
                                  Get.bottomSheet(BottomDialog(
                                      content: "LeaveGroupTip".trParams({"groupName": "${logic.bean.value?.name}"}),
                                      confirmText: "EXIT".tr,
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
                                    child: Text("Leave Group".tr,
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
                                child: Text("Clear Chat History".tr,
                                    style: GoogleFonts.roboto(fontSize: 15.sp, color: const Color(0xffDB5549))))),
                      ]))
                ]),
              );
            }));
  }
}
