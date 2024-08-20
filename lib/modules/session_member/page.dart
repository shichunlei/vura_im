import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:im/utils/color_util.dart';
import 'package:im/utils/device_utils.dart';
import 'package:im/widgets/obx_widget.dart';
import 'package:im/widgets/radius_inkwell_widget.dart';
import 'package:im/widgets/round_image.dart';

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
                            Text("张三",
                                style: GoogleFonts.roboto(
                                    fontSize: 18.sp, color: Colors.black, fontWeight: FontWeight.w600)),
                            SizedBox(height: 13.r),
                            Text("23423423424",
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
                            Text("管理员", style: GoogleFonts.roboto(color: ColorUtil.color_999999, fontSize: 15.sp))
                          ])),
                      const Divider(height: 0),
                      SizedBox(
                          height: 60.h,
                          child: Row(children: [
                            Text("昵称", style: GoogleFonts.roboto(color: ColorUtil.color_333333, fontSize: 15.sp)),
                            const Spacer(),
                            Text("张三", style: GoogleFonts.roboto(color: ColorUtil.color_999999, fontSize: 15.sp))
                          ]))
                    ])),
                const Spacer(),
                RadiusInkWellWidget(
                    child: Container(
                        height: 44.h,
                        width: 177.w,
                        alignment: Alignment.center,
                        child: Text("添加好友",
                            style:
                                GoogleFonts.roboto(fontSize: 18.sp, fontWeight: FontWeight.w600, color: Colors.white))),
                    onPressed: () {}),
                SizedBox(height: DeviceUtils.setBottomMargin(20.h))
              ]);
            }));
  }
}
