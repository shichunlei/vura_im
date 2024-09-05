import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vura/global/enum.dart';
import 'package:vura/modules/root/logic.dart';
import 'package:vura/utils/color_util.dart';
import 'package:vura/utils/device_utils.dart';
import 'package:vura/widgets/avatar_image.dart';
import 'package:vura/widgets/obx_widget.dart';
import 'package:vura/widgets/radius_inkwell_widget.dart';

import 'logic.dart';

class SessionMemberPage extends StatelessWidget {
  final String? tag;

  const SessionMemberPage({super.key, this.tag});

  SessionMemberLogic get logic => Get.find<SessionMemberLogic>(tag: tag);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("群成员信息"), centerTitle: true),
        body: BaseWidget(
            logic: logic,
            builder: (logic) {
              return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(11.r), color: Colors.white),
                    margin: EdgeInsets.symmetric(horizontal: 22.w, vertical: 11.h),
                    padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 22.h),
                    child: Row(children: [
                      AvatarRoundImage("${logic.bean.value?.headImage}",
                          width: 53.r, height: 53.r, radius: 5.r, name: logic.bean.value?.showNickName),
                      SizedBox(width: 13.w),
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                            Text("${logic.bean.value?.showNickName}",
                                style: GoogleFonts.roboto(
                                    fontSize: 18.sp, color: Colors.black, fontWeight: FontWeight.w600)),
                            SizedBox(height: 13.r),
                            Text("ID:${logic.bean.value?.userId}",
                                style: GoogleFonts.roboto(fontSize: 13.sp, color: ColorUtil.color_999999))
                          ]))
                    ])),
                Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(11.r), color: Colors.white),
                    margin: EdgeInsets.symmetric(horizontal: 22.w),
                    padding: EdgeInsets.symmetric(horizontal: 22.w),
                    child: Column(children: [
                      SizedBox(
                          height: 60.h,
                          child: Row(children: [
                            Text("群成员身份", style: GoogleFonts.roboto(color: ColorUtil.color_333333, fontSize: 15.sp)),
                            const Spacer(),
                            Text(
                                logic.bean.value?.isAdmin == YorNType.Y
                                    ? "群主"
                                    : logic.bean.value?.isSupAdmin == YorNType.Y
                                        ? "管理员"
                                        : "群成员",
                                style: GoogleFonts.roboto(color: ColorUtil.color_999999, fontSize: 15.sp))
                          ])),
                      const Divider(height: 0),
                      SizedBox(
                          height: 60.h,
                          child: Row(children: [
                            Text("昵称", style: GoogleFonts.roboto(color: ColorUtil.color_333333, fontSize: 15.sp)),
                            const Spacer(),
                            Text("${logic.bean.value?.showNickName}",
                                style: GoogleFonts.roboto(color: ColorUtil.color_999999, fontSize: 15.sp))
                          ])),
                      Visibility(visible: logic.isAdmin, child: const Divider(height: 0)),
                      Visibility(
                          visible: logic.isAdmin,
                          child: SizedBox(
                              height: 60.h,
                              child: Row(children: [
                                Text("禁止抢红包",
                                    style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_333333)),
                                const Spacer(),
                                CupertinoSwitch(
                                    value: logic.bean.value?.isVure == YorNType.N, onChanged: logic.setProhibitVure),
                              ])))
                    ])),
                const Spacer(),
                Get.find<RootLogic>().user.value?.id == logic.userId
                    ? const SizedBox()
                    : logic.bean.value?.friendship == YorNType.Y
                        ? RadiusInkWellWidget(
                            onPressed: () => logic.goChatPageByMember(logic.bean.value!),
                            child: Container(
                                height: 44.h,
                                width: 177.w,
                                alignment: Alignment.center,
                                child: Text("发消息",
                                    style: GoogleFonts.roboto(
                                        fontSize: 18.sp, fontWeight: FontWeight.w600, color: Colors.white))))
                        : logic.bean.value?.friendship == YorNType.N
                            ? RadiusInkWellWidget(
                                onPressed: () => logic.applyFriend(logic.userId),
                                child: Container(
                                    height: 44.h,
                                    width: 177.w,
                                    alignment: Alignment.center,
                                    child: Text("添加好友",
                                        style: GoogleFonts.roboto(
                                            fontSize: 18.sp, fontWeight: FontWeight.w600, color: Colors.white))))
                            : RadiusInkWellWidget(
                                color: Colors.redAccent,
                                onPressed: logic.removeFromBlacklist,
                                child: Container(
                                    height: 44.h,
                                    width: 177.w,
                                    alignment: Alignment.center,
                                    child: Text("移除黑名单",
                                        style: GoogleFonts.roboto(
                                            fontSize: 18.sp, fontWeight: FontWeight.w600, color: Colors.white)))),
                SizedBox(height: DeviceUtils.setBottomMargin(20.h))
              ]);
            }));
  }
}
