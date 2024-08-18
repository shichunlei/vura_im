import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:im/entities/user_entity.dart';
import 'package:im/global/icon_font.dart';
import 'package:im/global/keys.dart';
import 'package:im/route/route_path.dart';
import 'package:im/utils/color_util.dart';
import 'package:im/widgets/appbar_bottom_search_view.dart';
import 'package:im/widgets/custom_icon_button.dart';
import 'package:im/widgets/obx_widget.dart';
import 'package:im/widgets/radius_inkwell_widget.dart';
import 'package:im/widgets/round_image.dart';
import 'package:im/widgets/state_view/empty_page.dart';

import 'logic.dart';

class SessionPage extends StatelessWidget {
  const SessionPage({super.key});

  SessionLogic get logic => Get.find<SessionLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text("message".tr),
            actions: [
              CustomIconButton(icon: const Icon(IconFont.message, color: ColorUtil.color_333333), onPressed: () {}),
              CustomIconButton(
                  icon: const Icon(IconFont.add_square, color: ColorUtil.color_333333),
                  onPressed: () {
                    Get.toNamed(RoutePath.SELECT_CONTACTS_PAGE)?.then((value) {
                      if (value != null && value is List<UserEntity>) logic.createSession(value);
                    });
                  })
            ],
            centerTitle: false,
            bottom: AppBarBottomSearchView(onSubmitted: (String value) {}, hintText: "搜索")),
        body: BaseWidget(
            logic: logic,
            showEmpty: false,
            builder: (logic) {
              if (logic.list.isEmpty) {
                return const EmptyPage(text: "温馨提示：\n您现在还没有任何聊天消息\n快跟您的好友发起聊天吧~");
              }
              return ListView.separated(
                  itemBuilder: (_, index) {
                    return RadiusInkWellWidget(
                        color: Colors.transparent,
                        onPressed: () {
                          Get.toNamed(RoutePath.CHAT_PAGE,
                              arguments: {Keys.ID: logic.list[index].id, Keys.TYPE: logic.list[index].type});
                        },
                        radius: 0,
                        padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 22.h),
                        child: Row(children: [
                          RoundImage("${logic.list[index].headImage}",
                              width: 44.r,
                              height: 44.r,
                              radius: 9.r,
                              errorImage: logic.list[index].type == "private"
                                  ? "assets/images/default_face.webp"
                                  : "assets/images/default_group_head.webp",
                              placeholderImage: logic.list[index].type == "private"
                                  ? "assets/images/default_face.webp"
                                  : "assets/images/default_group_head.webp"),
                          SizedBox(width: 13.w),
                          Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                Text("${logic.list[index].name}",
                                    style: GoogleFonts.roboto(
                                        fontSize: 15.sp, color: ColorUtil.color_333333, fontWeight: FontWeight.w600)),
                                SizedBox(height: 3.h),
                                Text(logic.list[index].lastMessage?.content ?? "",
                                    style: GoogleFonts.roboto(fontSize: 13.sp, color: ColorUtil.color_999999))
                              ]))
                        ]));
                  },
                  itemCount: logic.list.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(height: 0, indent: 18.w, endIndent: 18.w));
            }));
  }
}
