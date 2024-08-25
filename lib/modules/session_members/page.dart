import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:im/utils/color_util.dart';
import 'package:im/widgets/appbar_bottom_search_view.dart';
import 'package:im/widgets/avatar_image.dart';
import 'package:im/widgets/obx_widget.dart';
import 'package:im/widgets/radius_inkwell_widget.dart';

import 'logic.dart';

class SessionMembersPage extends StatelessWidget {
  final String? tag;

  const SessionMembersPage({super.key, this.tag});

  SessionMembersLogic get logic => Get.find<SessionMembersLogic>(tag: tag);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(logic.title),
            centerTitle: true,
            bottom: AppBarBottomSearchView(onSubmitted: (String value) {}, hintText: "搜索")),
        body: BaseWidget(
            logic: logic,
            builder: (logic) {
              return ListView.separated(
                  padding: EdgeInsets.only(top: 8.h),
                  itemBuilder: (_, index) {
                    return GestureDetector(
                        onTap: () {},
                        behavior: HitTestBehavior.translucent,
                        child: Container(
                            color: Colors.white,
                            padding: EdgeInsets.only(right: 22.w, top: 11.h, bottom: 11.h),
                            child: Row(children: [
                              Container(
                                  alignment: Alignment.center,
                                  width: 46.w,
                                  child: Icon(Icons.check_circle, size: 10.r)),
                              AvatarImageView("${logic.list[index].headImage}",
                                  radius: 26.r, name: logic.list[index].remarkNickName),
                              SizedBox(width: 13.w),
                              Expanded(
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                    Text("${logic.list[index].remarkNickName}",
                                        style: GoogleFonts.roboto(
                                            fontSize: 18.sp,
                                            color: ColorUtil.color_333333,
                                            fontWeight: FontWeight.w500)),
                                    SizedBox(height: 5.r),
                                    Text("ID:${logic.list[index].userId}",
                                        style: GoogleFonts.roboto(fontSize: 11.sp, color: ColorUtil.color_999999))
                                  ])),
                              RadiusInkWellWidget(
                                  child: Container(
                                      width: 62.w,
                                      height: 26.h,
                                      alignment: Alignment.center,
                                      child: Text("查看详情",
                                          style: GoogleFonts.roboto(
                                              color: Colors.white, fontSize: 11.sp, fontWeight: FontWeight.w600))),
                                  onPressed: () {})
                            ])));
                  },
                  separatorBuilder: (_, index) {
                    return Divider(height: 0, indent: 46.w);
                  },
                  itemCount: logic.list.length);
            }));
  }
}
