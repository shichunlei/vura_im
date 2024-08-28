import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vura/global/enum.dart';
import 'package:vura/global/keys.dart';
import 'package:vura/route/route_path.dart';
import 'package:vura/utils/color_util.dart';
import 'package:vura/utils/toast_util.dart';
import 'package:vura/widgets/appbar_bottom_search_view.dart';
import 'package:vura/widgets/avatar_image.dart';
import 'package:vura/widgets/obx_widget.dart';
import 'package:vura/widgets/radius_inkwell_widget.dart';

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
            bottom: AppBarBottomSearchView(onSubmitted: (String value) {}, hintText: "搜索"),
            actions: logic.selectType == SelectType.none
                ? []
                : [
                    TextButton(
                        onPressed: () {
                          if (logic.maxCount != null &&
                              (logic.selectMembers.length + logic.selectIds.length) >= logic.maxCount!) {
                            showToast(text: "最多选择${logic.maxCount}个成员");
                            return;
                          }
                          if (logic.selectMembers.isEmpty && logic.selectUser.value == null) {
                            showToast(text: "请选择群成员");
                            return;
                          }
                          if (logic.selectType == SelectType.checkbox) {
                            Get.back(result: logic.selectMembers);
                          }
                          if (logic.selectType == SelectType.radio) {
                            Get.back(result: logic.selectUser.value);
                          }
                        },
                        child: const Text("确定"))
                  ]),
        body: BaseWidget(
            logic: logic,
            builder: (logic) {
              return ListView.separated(
                  padding: EdgeInsets.only(top: 8.h),
                  itemBuilder: (_, index) {
                    return GestureDetector(
                        onTap: logic.selectType == SelectType.none
                            ? null
                            : () {
                                if (logic.selectIds.any((item) => item == logic.list[index].userId)) return;
                                if (logic.selectType == SelectType.checkbox) {
                                  if (logic.selectMembers.any((item) => item.userId == logic.list[index].userId)) {
                                    logic.selectMembers.removeWhere((item) => item.userId == logic.list[index].userId);
                                  } else {
                                    logic.selectMembers.add(logic.list[index]);
                                  }
                                  logic.selectMembers.refresh();
                                }
                                if (logic.selectType == SelectType.radio) logic.selectUser.value = logic.list[index];
                              },
                        behavior: HitTestBehavior.translucent,
                        child: Container(
                            color: Colors.white,
                            padding: EdgeInsets.only(right: 22.w, top: 11.h, bottom: 11.h),
                            child: Row(children: [
                              logic.selectType != SelectType.none
                                  ? Container(
                                      alignment: Alignment.center,
                                      width: 46.w,
                                      child: Obx(() {
                                        return Icon(
                                            logic.selectIds.any((item) => item == logic.list[index].userId) ||
                                                    logic.selectMembers
                                                        .any((item) => item.userId == logic.list[index].userId) ||
                                                    logic.selectUser.value?.userId == logic.list[index].userId
                                                ? Icons.check_circle
                                                : Icons.circle_outlined,
                                            size: 10.r,
                                            color: logic.selectIds.any((item) => item == logic.list[index].userId)
                                                ? Theme.of(Get.context!).primaryColor.withOpacity(.5)
                                                : logic.selectMembers
                                                            .any((item) => item.userId == logic.list[index].userId) ||
                                                        logic.selectUser.value?.userId == logic.list[index].userId
                                                    ? Theme.of(Get.context!).primaryColor
                                                    : const Color(0xffdddddd));
                                      }))
                                  : SizedBox(width: 22.w),
                              AvatarImageView("${logic.list[index].headImage}",
                                  radius: 26.r, name: logic.list[index].showNickName),
                              SizedBox(width: 13.w),
                              Expanded(
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                    Text("${logic.list[index].showNickName}",
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
                                  onPressed: () {
                                    Get.toNamed(RoutePath.SESSION_MEMBER_PAGE,
                                        arguments: {Keys.ID: logic.list[index].userId, Keys.GROUP_ID: logic.id});
                                  })
                            ])));
                  },
                  separatorBuilder: (_, index) {
                    return Divider(height: 0, indent: logic.selectType != SelectType.none ? 46.w : 0);
                  },
                  itemCount: logic.list.length);
            }));
  }
}
