import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vura/global/enum.dart';
import 'package:vura/global/icon_font.dart';
import 'package:vura/global/keys.dart';
import 'package:vura/modules/root/logic.dart';
import 'package:vura/route/route_path.dart';
import 'package:vura/utils/color_util.dart';
import 'package:vura/widgets/appbar_bottom_search_view.dart';
import 'package:vura/widgets/avatar_image.dart';
import 'package:vura/widgets/obx_widget.dart';
import 'package:vura/widgets/radius_inkwell_widget.dart';

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
                    onPressed: logic.scan,
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
                          return GestureDetector(
                              onTap: logic.list[index].friendship == YorNType.Y ||
                                      logic.list[index].friendship == YorNType.M
                                  ? () {
                                      if (logic.list[index].friendship == YorNType.Y) {
                                        logic.goChatPage(logic.list[index]);
                                      }
                                      if (logic.list[index].friendship == YorNType.M) {
                                        Get.toNamed(RoutePath.MY_INFO_PAGE);
                                      }
                                    }
                                  : null,
                              behavior: HitTestBehavior.translucent,
                              child: Container(
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
                                          Row(children: [
                                            Text("${logic.list[index].nickName}",
                                                style: GoogleFonts.roboto(
                                                    fontSize: 18.sp,
                                                    color: ColorUtil.color_333333,
                                                    fontWeight: FontWeight.w500)),
                                            SizedBox(width: 10.w),
                                            Visibility(
                                                visible: logic.list[index].friendship == YorNType.B,
                                                child: Text("已拉黑",
                                                    style: GoogleFonts.roboto(
                                                        fontSize: 14.sp, color: ColorUtil.color_666666)))
                                          ]),
                                          SizedBox(height: 5.r),
                                          Text("ID:${logic.list[index].no}",
                                              style: GoogleFonts.roboto(fontSize: 11.sp, color: ColorUtil.color_999999))
                                        ])),
                                    Visibility(
                                        visible: logic.list[index].friendship == YorNType.N ||
                                            logic.list[index].friendship == YorNType.B,
                                        child: RadiusInkWellWidget(
                                            color: logic.list[index].friendship == YorNType.B
                                                ? Colors.redAccent
                                                : Theme.of(context).primaryColor,
                                            margin: EdgeInsets.only(right: 22.w),
                                            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                                            child: Text(logic.list[index].friendship == YorNType.N ? "添加好友" : "移除黑名单",
                                                style: GoogleFonts.roboto(
                                                    color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.w600)),
                                            onPressed: () {
                                              if (logic.list[index].friendship == YorNType.N) {
                                                logic.applyFriend(logic.list[index].id);
                                              }
                                              if (logic.list[index].friendship == YorNType.B) {
                                                logic.removeFromBlacklist(index);
                                              }
                                            }))
                                  ])));
                        },
                        separatorBuilder: (_, index) => const Divider(height: 0),
                        itemCount: logic.list.length))
              ]);
            }));
  }
}
