import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vura/global/enum.dart';
import 'package:vura/utils/color_util.dart';
import 'package:vura/utils/dialog_util.dart';
import 'package:vura/widgets/widgets.dart';

import 'logic.dart';

class PrivateSessionDetailPage extends StatelessWidget {
  final String? tag;

  const PrivateSessionDetailPage({super.key, this.tag});

  PrivateSessionDetailLogic get logic => Get.find<PrivateSessionDetailLogic>(tag: tag);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Chat Info".tr), centerTitle: true),
        body: BaseWidget(
            logic: logic,
            builder: (logic) {
              return SingleChildScrollView(
                child: Column(children: [
                  Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(11.r), color: Colors.white),
                      margin: EdgeInsets.symmetric(horizontal: 22.w, vertical: 11.h),
                      padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 22.h),
                      child: Row(children: [
                        AvatarRoundImage("${logic.bean.value?.headImage}",
                            width: 53.r, height: 53.r, radius: 5.r, onTap: () {}, name: logic.bean.value?.name),
                        SizedBox(width: 13.w),
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                              Text("${logic.bean.value?.name}",
                                  style: GoogleFonts.roboto(
                                      fontSize: 18.sp, color: Colors.black, fontWeight: FontWeight.w600)),
                              SizedBox(height: 13.r),
                              Text("ID:${logic.id}", // todo
                                  style: GoogleFonts.roboto(fontSize: 13.sp, color: ColorUtil.color_999999))
                            ]))
                      ])),
                  Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(11.r), color: Colors.white),
                      margin: EdgeInsets.symmetric(horizontal: 22.w),
                      child: Column(children: [
                        Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.only(topLeft: Radius.circular(11.r), topRight: Radius.circular(11.r))),
                            height: 60.h,
                            padding: EdgeInsets.only(left: 22.w, right: 22.w),
                            child: Row(children: [
                              Text("Nickname".tr,
                                  style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_333333)),
                              const Spacer(),
                              Text("${logic.bean.value?.name}",
                                  style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_999999))
                            ])),
                        Divider(height: 0, indent: 22.w, endIndent: 22.w),
                        // RadiusInkWellWidget(
                        //     color: Colors.transparent,
                        //     onPressed: () {
                        //       Get.dialog(UpdateTextDialog(title: "请输入备注", value: logic.bean.value?.name ?? ""))
                        //           .then((value) {
                        //         if (value != null) logic.updateRemarkName(value);
                        //       });
                        //     },
                        //     radius: 0,
                        //     child: Container(
                        //         height: 60.h,
                        //         padding: EdgeInsets.only(left: 22.w, right: 10.w),
                        //         child: Row(children: [
                        //           Text("设置备注",
                        //               style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_333333)),
                        //           const Spacer(),
                        //           Text(logic.bean.value?.remarkNickName ?? "前往设置",
                        //               style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_999999)),
                        //           const Icon(Icons.keyboard_arrow_right, color: ColorUtil.color_999999)
                        //         ]))),
                        // Divider(height: 0, indent: 22.w, endIndent: 22.w),
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
                            ])),
                        Divider(height: 0, indent: 22.w, endIndent: 22.w),
                        Container(
                            height: 60.h,
                            padding: EdgeInsets.only(left: 22.w, right: 15.w),
                            child: Row(children: [
                              Text("加入黑名单", style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_333333)),
                              const Spacer(),
                              CupertinoSwitch(
                                  value: logic.bean.value?.friendship == YorNType.B,
                                  onChanged: (value) {
                                    if (value) {
                                      Get.bottomSheet(BottomDialog(
                                          content: "加入黑名单，你将不再接受对方的消息",
                                          onConfirm: () {
                                            logic.addBlacklist();
                                          }));
                                    } else {
                                      logic.removeFromBlacklist();
                                    }
                                  })
                            ]))
                      ])),
                  Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(11.r), color: Colors.white),
                      margin: EdgeInsets.symmetric(horizontal: 22.w, vertical: 11.h),
                      child: Column(children: [
                        RadiusInkWellWidget(
                            color: Colors.transparent,
                            onPressed: logic.deleteFriend,
                            borderRadius:
                                BorderRadius.only(topLeft: Radius.circular(11.r), topRight: Radius.circular(11.r)),
                            child: Container(
                                height: 60.h,
                                padding: EdgeInsets.only(left: 22.w),
                                alignment: Alignment.centerLeft,
                                child: Text("Delete Friend".tr,
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
