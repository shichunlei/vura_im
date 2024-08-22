import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:im/global/icon_font.dart';
import 'package:im/global/keys.dart';
import 'package:im/modules/root/logic.dart';
import 'package:im/route/route_path.dart';
import 'package:im/utils/color_util.dart';
import 'package:im/widgets/appbar_bottom_search_view.dart';
import 'package:im/widgets/avatar_image.dart';
import 'package:im/widgets/obx_widget.dart';
import 'package:im/widgets/radius_inkwell_widget.dart';

import 'logic.dart';

class AddFriendPage extends StatelessWidget {
  const AddFriendPage({super.key});

  AddFriendLogic get logic => Get.find<AddFriendLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            title: const Text("添加好友"),
            centerTitle: true,
            bottom: AppBarBottomSearchView(onSubmitted: logic.search, hintText: "搜索")),
        body: BaseWidget(
            logic: logic,
            showEmpty: false,
            showLoading: false,
            builder: (logic) {
              return Column(children: [
                RadiusInkWellWidget(
                    onPressed: () {},
                    color: Colors.transparent,
                    radius: 0,
                    padding: EdgeInsets.symmetric(horizontal: 22.w),
                    child: SizedBox(
                        height: 60.h,
                        child: Row(children: [
                          Icon(IconFont.scan, color: ColorUtil.color_333333, size: 22.r),
                          SizedBox(width: 20.w),
                          Text("扫一扫", style: GoogleFonts.roboto(color: ColorUtil.color_333333, fontSize: 13.sp)),
                          const Spacer(),
                          const Icon(Icons.keyboard_arrow_right, color: ColorUtil.color_999999)
                        ]))),
                Divider(height: 0, indent: 22.w, endIndent: 22.w),
                RadiusInkWellWidget(
                    onPressed: () {
                      Get.toNamed(RoutePath.MY_QR_CODE_PAGE,
                          arguments: {Keys.ID: Get.find<RootLogic>().user.value?.id});
                    },
                    color: Colors.transparent,
                    radius: 0,
                    padding: EdgeInsets.symmetric(horizontal: 22.w),
                    child: SizedBox(
                        height: 60.h,
                        child: Row(children: [
                          Icon(IconFont.qr, color: ColorUtil.color_333333, size: 22.r),
                          SizedBox(width: 20.w),
                          Text("我的二维码", style: GoogleFonts.roboto(color: ColorUtil.color_333333, fontSize: 13.sp)),
                          const Spacer(),
                          const Icon(Icons.keyboard_arrow_right, color: ColorUtil.color_999999)
                        ]))),
                const Divider(height: 0),
                Expanded(
                    child: ListView.separated(
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
                                              fontSize: 18.sp,
                                              color: ColorUtil.color_333333,
                                              fontWeight: FontWeight.w500)),
                                      SizedBox(height: 5.r),
                                      Text("data",
                                          style: GoogleFonts.roboto(fontSize: 11.sp, color: ColorUtil.color_999999))
                                    ])),
                                RadiusInkWellWidget(
                                    margin: EdgeInsets.only(right: 22.w),
                                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                                    child: Text("添加好友",
                                        style: GoogleFonts.roboto(
                                            color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.w600)),
                                    onPressed: () => logic.applyFriend(index))
                              ]));
                        },
                        separatorBuilder: (_, index) => const Divider(height: 0),
                        itemCount: logic.list.length))
              ]);
            }));
  }
}
