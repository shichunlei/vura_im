import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:im/global/enum.dart';
import 'package:im/utils/color_util.dart';
import 'package:im/utils/device_utils.dart';
import 'package:im/utils/string_util.dart';
import 'package:im/widgets/obx_widget.dart';
import 'package:im/widgets/radius_inkwell_widget.dart';
import 'package:im/widgets/round_image.dart';

import 'logic.dart';

class UserInfoPage extends StatelessWidget {
  final String? tag;

  const UserInfoPage({super.key, this.tag});

  UserInfoLogic get logic => Get.find<UserInfoLogic>(tag: tag);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("用户信息"), centerTitle: true),
        body: BaseWidget(
            logic: logic,
            builder: (logic) {
              return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(11.r), color: Colors.white),
                    margin: EdgeInsets.symmetric(horizontal: 22.w, vertical: 11.h),
                    padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 22.h),
                    child: Row(children: [
                      RoundImage(logic.bean.value?.headImage,
                          width: 53.r,
                          height: 53.r,
                          radius: 5.r,
                          errorWidget: StringUtil.isNotEmpty(logic.bean.value?.nickName)
                              ? Container(
                                  width: 53.r,
                                  height: 53.r,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.r),
                                      border: Border.all(color: Colors.white, width: 1),
                                      color: ColorUtil.strToColor(logic.bean.value!.nickName!)),
                                  alignment: Alignment.center,
                                  child: FittedBox(
                                      fit: BoxFit.contain,
                                      child: Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Text(logic.bean.value!.nickName![0],
                                              style: TextStyle(fontSize: 20.sp, color: Colors.white)))))
                              : Image.asset("assets/images/default_face.webp", width: 53.r, height: 53.r),
                          placeholderImage: "assets/images/default_face.webp"),
                      SizedBox(width: 13.w),
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                            Text("${logic.bean.value?.nickName}",
                                style: GoogleFonts.roboto(
                                    fontSize: 18.sp, color: Colors.black, fontWeight: FontWeight.w600)),
                            SizedBox(height: 13.r),
                            Text("ID:${logic.bean.value?.id}",
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
                            Text("昵称", style: GoogleFonts.roboto(color: ColorUtil.color_333333, fontSize: 15.sp)),
                            const Spacer(),
                            Text("${logic.bean.value?.nickName}",
                                style: GoogleFonts.roboto(color: ColorUtil.color_999999, fontSize: 15.sp))
                          ])),
                      const Divider(height: 0),
                      SizedBox(
                          height: 60.h,
                          child: Row(children: [
                            Text("性别", style: GoogleFonts.roboto(color: ColorUtil.color_333333, fontSize: 15.sp)),
                            const Spacer(),
                            Text("${logic.bean.value?.sex}",
                                style: GoogleFonts.roboto(color: ColorUtil.color_999999, fontSize: 15.sp))
                          ]))
                    ])),
                const Spacer(),
                logic.bean.value?.friendship == YorNType.Y
                    ? RadiusInkWellWidget(
                        radius: 4.r,
                        onPressed: () => logic.goChatPage(logic.bean.value!),
                        child: Container(
                            height: 44.h,
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: Text("发消息",
                                style: GoogleFonts.roboto(
                                    fontSize: 18.sp, fontWeight: FontWeight.w600, color: Colors.white))))
                    : logic.bean.value?.friendship == YorNType.N
                        ? RadiusInkWellWidget(
                            radius: 4.r,
                            onPressed: () => logic.applyFriend(logic.userId),
                            child: Container(
                                height: 44.h,
                                width: double.infinity,
                                alignment: Alignment.center,
                                child: Text("添加好友",
                                    style: GoogleFonts.roboto(
                                        fontSize: 18.sp, fontWeight: FontWeight.w600, color: Colors.white))))
                        : RadiusInkWellWidget(
                            radius: 4.r,
                            color: Colors.redAccent,
                            onPressed: logic.removeFromBlacklist,
                            child: Container(
                                height: 44.h,
                                width: double.infinity,
                                alignment: Alignment.center,
                                child: Text("移除黑名单",
                                    style: GoogleFonts.roboto(
                                        fontSize: 18.sp, fontWeight: FontWeight.w600, color: Colors.white)))),
                SizedBox(height: DeviceUtils.setBottomMargin(20.h))
              ]);
            }));
  }
}
