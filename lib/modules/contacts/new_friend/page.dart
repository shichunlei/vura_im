import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vura/global/keys.dart';
import 'package:vura/route/route_path.dart';
import 'package:vura/utils/color_util.dart';
import 'package:vura/widgets/avatar_image.dart';
import 'package:vura/widgets/custom_refresh_widget.dart';
import 'package:vura/widgets/obx_widget.dart';
import 'package:vura/widgets/radius_inkwell_widget.dart';

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
              return CustomRefreshWidget(
                  controller: logic.easyRefreshController,
                  onRefresh: () async => await logic.refreshData(),
                  onLoad: logic.list.length < logic.pageSize.value ? null : () async => await logic.loadMore(),
                  itemBuilder: (_, index) {
                    return GestureDetector(
                        onTap: logic.list[index].applyStatus == "0"
                            ? null
                            : () {
                                Get.toNamed(RoutePath.USER_INFO_PAGE, arguments: {Keys.ID: logic.list[index].userId});
                              },
                        behavior: HitTestBehavior.translucent,
                        child: Container(
                            margin: const EdgeInsets.only(bottom: 1),
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
                                    Text(logic.list[index].createTime ?? "",
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
                                          style: GoogleFonts.roboto(
                                              fontSize: 12.sp,
                                              color: logic.list[index].applyStatus == "2"
                                                  ? Colors.redAccent
                                                  : ColorUtil.color_999999)))
                            ])));
                  },
                  itemCount: logic.list.length,
                  padding: EdgeInsets.only(top: 5.h));
            }));
  }
}
