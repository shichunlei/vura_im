import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vura/entities/user_entity.dart';
import 'package:vura/global/icon_font.dart';
import 'package:vura/modules/im/widgets/item_session.dart';
import 'package:vura/route/route_path.dart';
import 'package:vura/utils/color_util.dart';
import 'package:vura/utils/dialog_util.dart';
import 'package:vura/widgets/appbar_bottom_search_view.dart';
import 'package:vura/widgets/custom_icon_button.dart';
import 'package:vura/widgets/obx_widget.dart';
import 'package:vura/widgets/radius_inkwell_widget.dart';
import 'package:vura/widgets/state_view/empty_page.dart';
import 'package:vura/widgets/text_marquee.dart';

import 'logic.dart';

class SessionPage extends StatelessWidget {
  const SessionPage({super.key});

  SessionLogic get logic => Get.find<SessionLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorUtil.secondBgColor,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            backgroundColor: ColorUtil.secondBgColor,
            title: Text("message".tr),
            actions: [
              CustomIconButton(
                  icon: const Icon(IconFont.message, color: ColorUtil.color_333333),
                  onPressed: () {
                    Get.toNamed(RoutePath.SESSIONS_PAGE);
                  }),
              CustomIconButton(
                  icon: const Icon(IconFont.add_square, color: ColorUtil.color_333333),
                  onPressed: () {
                    Get.toNamed(RoutePath.SELECT_CONTACTS_PAGE, arguments: {"isCheckBox": true})?.then((value) {
                      if (value != null && value is List<UserEntity>) logic.createSession(value);
                    });
                  })
            ],
            centerTitle: false,
            bottom: AppBarBottomSearchView(
                searchBgColor: Colors.white, onSubmitted: (String value) {}, hintText: "Search".tr)),
        body: BaseWidget(
            logic: logic,
            showEmpty: false,
            bgColor: Colors.transparent,
            builder: (logic) {
              return Column(children: [
                SizedBox(
                    height: 44.h,
                    child: Row(children: [
                      SizedBox(width: 22.w),
                      Icon(IconFont.notice2, color: ColorUtil.color_666666, size: 18.sp),
                      SizedBox(width: 11.w),
                      Expanded(
                          child: TextMarquee("欢迎来到vura，祝大家生活愉快，前程似锦！欢迎来到vura，祝大家生活愉快，前程似锦！",
                              style: TextStyle(color: ColorUtil.color_666666, fontSize: 13.sp),
                              delay: Duration.zero,
                              duration: const Duration(seconds: 10),
                              spaceSize: 0)),
                      SizedBox(width: 22.w)
                    ])),
                const Divider(height: 0),
                Expanded(
                    child: logic.list.isEmpty
                        ? const EmptyPage(text: "温馨提示：\n您现在还没有任何聊天消息\n快跟您的好友发起聊天吧~", bgColor: Colors.transparent)
                        : ListView.separated(
                            itemBuilder: (_, index) {
                              return ItemSession(
                                  session: logic.list[index],
                                  onLongPress: () {
                                    showToolDialog(index);
                                  });
                            },
                            itemCount: logic.list.length,
                            separatorBuilder: (BuildContext context, int index) =>
                                Divider(height: 0, indent: 18.w, endIndent: 18.w, color: Colors.transparent)))
              ]);
            }));
  }

  void showToolDialog(int index) {
    show(builder: (_) {
      return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r), color: Get.theme.cardColor),
            width: 250.w,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              RadiusInkWellWidget(
                  radius: 0,
                  color: Colors.transparent,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(8.r), topLeft: Radius.circular(8.r)),
                  onPressed: () {
                    Get.back();
                    logic.setTop(index);
                  },
                  child: Container(
                      height: 50.h,
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Text(logic.list[index].moveTop ? "取消置顶" : "置顶",
                          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)))),
              const Divider(height: .5),
              RadiusInkWellWidget(
                  radius: 0,
                  color: Colors.transparent,
                  child: Container(
                      height: 50.h,
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Text(logic.list[index].isDisturb ? "取消免打扰" : "消息免打扰",
                          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600))),
                  onPressed: () {
                    Get.back();
                    logic.setDisturb(index);
                  }),
              const Divider(height: .5),
              RadiusInkWellWidget(
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(8.r), bottomLeft: Radius.circular(8.r)),
                  color: Colors.transparent,
                  child: Container(
                      height: 50.h,
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Text("删除会话", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600))),
                  onPressed: () {
                    Get.back();
                    logic.removeSession(index);
                  })
            ]))
      ]);
    });
  }
}
