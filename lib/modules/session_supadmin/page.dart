import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:im/global/icon_font.dart';
import 'package:im/utils/color_util.dart';
import 'package:im/widgets/avatar_image.dart';
import 'package:im/widgets/obx_widget.dart';

import 'logic.dart';

class SessionSupAdminPage extends StatelessWidget {
  final String? tag;

  const SessionSupAdminPage({super.key, this.tag});

  SessionSupAdminLogic get logic => Get.find<SessionSupAdminLogic>(tag: tag);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor: Colors.transparent),
        body: BaseWidget(
            logic: logic,
            builder: (logic) {
              return Container(
                  padding: EdgeInsets.symmetric(horizontal: 42.w),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    SizedBox(height: 50.h),
                    Container(
                        alignment: Alignment.center,
                        child: Text("群管理员",
                            style: GoogleFonts.roboto(
                                fontSize: 18.sp, fontWeight: FontWeight.bold, color: ColorUtil.color_333333))),
                    SizedBox(height: 40.h),
                    Text(" · 管理员可协助群主管理群聊，拥有发布群公告、移除群成员等能力。",
                        style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_333333, height: 1.5)),
                    Text(" · 只有群主具备设置管理员、解散群聊的能力。",
                        style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_333333, height: 1.5)),
                    Text(" · 最多可设置3个管理员。",
                        style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_333333, height: 1.5)),
                    SizedBox(height: 50.h),
                    ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.only(top: 8.h),
                        itemBuilder: (_, index) {
                          if (logic.list.length < 3 && index == logic.list.length) {
                            return Container(
                                padding: EdgeInsets.only(top: 11.h, bottom: 11.h),
                                child: GestureDetector(
                                    onTap: () {},
                                    behavior: HitTestBehavior.translucent,
                                    child: Row(children: [
                                      Icon(IconFont.add_round, size: 44.r),
                                      SizedBox(width: 13.w),
                                      const Text("添加成员")
                                    ])));
                          }

                          return Container(
                              padding: EdgeInsets.only(top: 11.h, bottom: 11.h),
                              child: Row(children: [
                                AvatarImageView("${logic.list[index].headImage}",
                                    radius: 22.r, name: logic.list[index].remarkNickName),
                                SizedBox(width: 13.w),
                                Expanded(
                                    child: Text("${logic.list[index].remarkNickName}",
                                        style: GoogleFonts.roboto(
                                            fontSize: 18.sp,
                                            color: ColorUtil.color_333333,
                                            fontWeight: FontWeight.w500))),
                                TextButton(onPressed: () {}, child: const Text("移除"))
                              ]));
                        },
                        separatorBuilder: (_, index) {
                          return const Divider(height: 0);
                        },
                        itemCount: logic.list.length < 3 ? logic.list.length + 1 : logic.list.length)
                  ]));
            }));
  }
}
