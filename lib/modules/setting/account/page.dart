import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vura/global/icon_font.dart';
import 'package:vura/utils/color_util.dart';
import 'package:vura/utils/dialog_util.dart';
import 'package:vura/widgets/avatar_image.dart';
import 'package:vura/widgets/dialog/alert_dialog.dart';
import 'package:vura/widgets/obx_widget.dart';

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
            showEmpty: false,
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
                                        Icon(IconFont.add_round, size: 44.r),
                                        SizedBox(width: 13.w),
                                        const Text("添加或注册账号")
                                      ])));
                            }
                            return GestureDetector(
                                onTap: () {
                                  show(builder: (_) {
                                    return CustomAlertDialog(
                                        title: "切换用户",
                                        content: "确认要切换到用户${logic.list[index].nickName}吗？",
                                        confirmText: "切换",
                                        onConfirm: () {
                                          logic.switchAccount(index);
                                        });
                                  });
                                },
                                behavior: HitTestBehavior.translucent,
                                child: Container(
                                    padding: EdgeInsets.only(left: 22.w, right: 30.w),
                                    height: 80.r,
                                    child: Row(children: [
                                      AvatarImageView("${logic.list[index].headImage}",
                                          radius: 22.r, name: "${logic.list[index].nickName}"),
                                      SizedBox(width: 13.w),
                                      Expanded(
                                          child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                            Text("${logic.list[index].nickName}",
                                                style: GoogleFonts.roboto(
                                                    fontSize: 15.sp,
                                                    color: ColorUtil.color_333333,
                                                    fontWeight: FontWeight.bold)),
                                            SizedBox(height: 3.h),
                                            Text("${logic.list[index].userName}",
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
