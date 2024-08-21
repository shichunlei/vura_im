import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:im/global/icon_font.dart';
import 'package:im/utils/color_util.dart';
import 'package:im/widgets/avatar_image.dart';
import 'package:im/widgets/obx_widget.dart';

import 'logic.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  AccountLogic get logic => Get.find<AccountLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("账号管理"), centerTitle: true),
        body: BaseWidget(
            logic: logic,
            builder: (logic) {
              return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 22.h),
                  child: Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(11.r), color: Colors.white),
                      child: ListView.separated(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (_, index) {
                            if (index == logic.list.length) {
                              return Container(
                                  padding: EdgeInsets.only(left: 22.w),
                                  height: 80.r,
                                  child: GestureDetector(
                                      onTap: () {},
                                      behavior: HitTestBehavior.translucent,
                                      child: Row(children: [
                                        Icon(IconFont.add, size: 44.r),
                                        SizedBox(width: 13.w),
                                        const Text("添加或注册账号")
                                      ])));
                            }
                            return GestureDetector(
                                onTap: () {
                                  logic.selectIndex.value = index;
                                },
                                behavior: HitTestBehavior.translucent,
                                child: Container(
                                    padding: EdgeInsets.only(left: 22.w, right: 30.w),
                                    height: 80.r,
                                    child: Row(children: [
                                      AvatarImageView(
                                          "https://p1.itc.cn/q_70/images03/20220714/e3e968b1d3484c70a00a1c130472c91f.jpeg",
                                          radius: 22.r,
                                          name: ""),
                                      SizedBox(width: 13.w),
                                      Expanded(
                                          child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                            Text("张三",
                                                style: GoogleFonts.roboto(
                                                    fontSize: 15.sp,
                                                    color: ColorUtil.color_333333,
                                                    fontWeight: FontWeight.bold)),
                                            SizedBox(height: 3.h),
                                            Text("223423423423",
                                                style:
                                                    GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_999999))
                                          ])),
                                      Obx(() {
                                        return Visibility(
                                            visible: logic.selectIndex.value == index,
                                            child: Icon(IconFont.check, size: 15.r));
                                      })
                                    ])));
                          },
                          separatorBuilder: (_, index) {
                            return Divider(indent: 22.w, endIndent: 22.w, height: 0);
                          },
                          itemCount: logic.list.length + 1)));
            }));
  }
}
