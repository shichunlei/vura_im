import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:im/utils/color_util.dart';
import 'package:im/widgets/avatar_image.dart';
import 'package:im/widgets/obx_widget.dart';
import 'package:im/widgets/radius_inkwell_widget.dart';

import 'logic.dart';

class NewFriendPage extends StatelessWidget {
  const NewFriendPage({super.key});

  NewFriendLogic get logic => Get.find<NewFriendLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("新的好友"), centerTitle: true),
        body: BaseWidget(
            logic: logic,
            builder: (logic) {
              return ListView.separated(
                  itemBuilder: (_, index) {
                    return Container(
                        padding: EdgeInsets.symmetric(vertical: 11.h),
                        child: Row(children: [
                          SizedBox(width: 22.w),
                          AvatarImageView("${logic.list[index].nickName}",
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
                                Text("ID:${logic.list[index].userId}",
                                    style: GoogleFonts.roboto(fontSize: 11.sp, color: ColorUtil.color_999999))
                              ])),
                          RadiusInkWellWidget(
                              color: Colors.redAccent,
                              margin: EdgeInsets.only(right: 10.w),
                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                              child: Text("拒绝",
                                  style: GoogleFonts.roboto(
                                      color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.w600)),
                              onPressed: () => logic.refused(index)),
                          RadiusInkWellWidget(
                              margin: EdgeInsets.only(right: 22.w),
                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                              child: Text("同意",
                                  style: GoogleFonts.roboto(
                                      color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.w600)),
                              onPressed: () => logic.agree(index))
                        ]));
                  },
                  separatorBuilder: (_, index) => const Divider(height: 0),
                  itemCount: logic.list.length);
            }));
  }
}
