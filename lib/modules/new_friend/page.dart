import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:im/global/keys.dart';
import 'package:im/route/route_path.dart';
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
                    return GestureDetector(
                        onTap: logic.list[index].applyStatus == "0"
                            ? null
                            : () {
                                Get.toNamed(RoutePath.USER_INFO_PAGE, arguments: {Keys.ID: logic.list[index].userId});
                              },
                        behavior: HitTestBehavior.translucent,
                        child: Container(
                            color: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 11.h, horizontal: 22.w),
                            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                                            fontSize: 18.sp,
                                            color: ColorUtil.color_333333,
                                            fontWeight: FontWeight.w500)),
                                    SizedBox(height: 5.r),
                                    Text(logic.list[index].reason ?? "",
                                        style: GoogleFonts.roboto(fontSize: 11.sp, color: ColorUtil.color_999999))
                                  ])),
                              Container(
                                  height: 52.r,
                                  alignment: Alignment.center,
                                  child: logic.list[index].applyStatus == "0"
                                      ? Row(children: [
                                          RadiusInkWellWidget(
                                              color: Colors.redAccent,
                                              margin: EdgeInsets.only(right: 10.w),
                                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                                              child: Text("拒绝",
                                                  style: GoogleFonts.roboto(
                                                      color: Colors.white,
                                                      fontSize: 12.sp,
                                                      fontWeight: FontWeight.w600)),
                                              onPressed: () => logic.refused(index)),
                                          RadiusInkWellWidget(
                                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                                              child: Text("同意",
                                                  style: GoogleFonts.roboto(
                                                      color: Colors.white,
                                                      fontSize: 12.sp,
                                                      fontWeight: FontWeight.w600)),
                                              onPressed: () => logic.agree(index))
                                        ])
                                      : Text(logic.list[index].applyStatus == "1" ? "已添加" : "已拒绝",
                                          style: GoogleFonts.roboto(fontSize: 12.sp, color: ColorUtil.color_999999)))
                            ])));
                  },
                  separatorBuilder: (_, index) => const Divider(height: 0),
                  itemCount: logic.list.length);
            }));
  }
}
