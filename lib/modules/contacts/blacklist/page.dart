import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vura/utils/color_util.dart';
import 'package:vura/widgets/avatar_image.dart';
import 'package:vura/widgets/dialog/bottom_dialog.dart';
import 'package:vura/widgets/obx_widget.dart';
import 'package:vura/widgets/radius_inkwell_widget.dart';

import 'logic.dart';

class BlacklistPage extends StatelessWidget {
  const BlacklistPage({super.key});

  BlacklistLogic get logic => Get.find<BlacklistLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("黑名单"), centerTitle: true),
        body: BaseWidget(
            logic: logic,
            builder: (logic) {
              return ListView.separated(
                  itemBuilder: (_, index) {
                    return Container(
                        padding: EdgeInsets.symmetric(vertical: 11.h),
                        child: Row(children: [
                          SizedBox(width: 22.w),
                          AvatarImageView("${logic.list[index].headImage}",
                              radius: 26.r, name: logic.list[index].nickName),
                          SizedBox(width: 18.w),
                          Expanded(
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                Text("${logic.list[index].nickName}",
                                    style: GoogleFonts.roboto(
                                        fontSize: 18.sp, color: ColorUtil.color_333333, fontWeight: FontWeight.w500)),
                                SizedBox(height: 5.r),
                                Text("ID:${logic.list[index].id}",
                                    style: GoogleFonts.roboto(fontSize: 11.sp, color: ColorUtil.color_999999))
                              ])),
                          RadiusInkWellWidget(
                              color: Colors.deepOrange,
                              margin: EdgeInsets.only(right: 22.w),
                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                              child: Text("移除",
                                  style: GoogleFonts.roboto(
                                      color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.w600)),
                              onPressed: () {
                                logic.remove(index);
                              })
                        ]));
                  },
                  separatorBuilder: (_, index) => const Divider(height: 0),
                  itemCount: logic.list.length);
            }));
  }
}
