import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vura/utils/color_util.dart';
import 'package:vura/widgets/widgets.dart';

import 'logic.dart';

class MutePage extends StatelessWidget {
  final String? tag;

  const MutePage({super.key, this.tag});

  MuteLogic get logic => Get.find<MuteLogic>(tag: tag);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("禁言列表"), centerTitle: true),
        body: BaseWidget(
            logic: logic,
            builder: (logic) {
              return ListView.separated(
                  padding: EdgeInsets.only(top: 8.h),
                  itemBuilder: (_, index) {
                    return Container(
                        color: Colors.white,
                        padding: EdgeInsets.only(left: 22.w, right: 22.w, top: 11.h, bottom: 11.h),
                        child: Row(children: [
                          AvatarImageView("${logic.list[index].headImage}",
                              radius: 26.r, name: logic.list[index].showNickName),
                          SizedBox(width: 13.w),
                          Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                Text("${logic.list[index].showNickName}",
                                    style: GoogleFonts.roboto(
                                        fontSize: 18.sp, color: ColorUtil.color_333333, fontWeight: FontWeight.w500)),
                                SizedBox(height: 5.r),
                                Text("ID:${logic.list[index].userId}",
                                    style: GoogleFonts.roboto(fontSize: 11.sp, color: ColorUtil.color_999999))
                              ])),
                          RadiusInkWellWidget(
                              margin: EdgeInsets.only(left: 13.w),
                              child: Container(
                                  width: 62.w,
                                  height: 26.h,
                                  alignment: Alignment.center,
                                  child: Text("解除禁言",
                                      style: GoogleFonts.roboto(
                                          color: Colors.white, fontSize: 11.sp, fontWeight: FontWeight.w600))),
                              onPressed: () => logic.resetMute(index))
                        ]));
                  },
                  separatorBuilder: (_, index) {
                    return Divider(height: 0, indent: 35.w + 52.r);
                  },
                  itemCount: logic.list.length);
            }));
  }
}
