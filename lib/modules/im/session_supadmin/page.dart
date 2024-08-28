import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vura/entities/member_entity.dart';
import 'package:vura/global/enum.dart';
import 'package:vura/global/icon_font.dart';
import 'package:vura/global/keys.dart';
import 'package:vura/route/route_path.dart';
import 'package:vura/utils/color_util.dart';
import 'package:vura/utils/dialog_util.dart';
import 'package:vura/widgets/avatar_image.dart';
import 'package:vura/widgets/dialog/alert_dialog.dart';
import 'package:vura/widgets/dialog/bottom_dialog.dart';
import 'package:vura/widgets/obx_widget.dart';

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
            showEmpty: false,
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
                                    onTap: () {
                                      Get.toNamed(RoutePath.SESSION_MEMBERS_PAGE, arguments: {
                                        Keys.ID: logic.id,
                                        Keys.TITLE: "设置管理员",
                                        "selectType": SelectType.checkbox,
                                        "includeMe": false,
                                        "selectIds": logic.list.map((item) => item.userId).toList(),
                                        "maxCount": 3
                                      })?.then((value) {
                                        if (value != null) {
                                          show(builder: (_) {
                                            return CustomAlertDialog(
                                                title: "提示",
                                                content:
                                                    "您确认要将${(value as List<MemberEntity>).map((item) => item.showNickName).toList().join(",")}设置为管理员吗？",
                                                onConfirm: () {
                                                  logic.addSupAdmin(value);
                                                });
                                          });
                                        }
                                      });
                                    },
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
                                    radius: 22.r, name: logic.list[index].showNickName),
                                SizedBox(width: 13.w),
                                Expanded(
                                    child: Text("${logic.list[index].showNickName}",
                                        style: GoogleFonts.roboto(
                                            fontSize: 18.sp,
                                            color: ColorUtil.color_333333,
                                            fontWeight: FontWeight.w500))),
                                TextButton(
                                    onPressed: () {
                                      Get.bottomSheet(BottomDialog(
                                          content: "您确认要移除管理员${logic.list[index].showNickName}吗？",
                                          confirmText: "移除",
                                          onConfirm: () {
                                            logic.removeSupAdmin(logic.list[index].userId);
                                          }));
                                    },
                                    child: const Text("移除"))
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
