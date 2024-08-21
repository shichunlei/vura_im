import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:im/entities/user_entity.dart';
import 'package:im/global/icon_font.dart';
import 'package:im/modules/sessions/widgets/item_session.dart';
import 'package:im/route/route_path.dart';
import 'package:im/utils/color_util.dart';
import 'package:im/widgets/appbar_bottom_search_view.dart';
import 'package:im/widgets/custom_icon_button.dart';
import 'package:im/widgets/obx_widget.dart';
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
              CustomIconButton(
                  icon: const Icon(IconFont.message, color: ColorUtil.color_333333),
                  onPressed: () {
                    Get.toNamed(RoutePath.SESSIONS_PAGE);
                  }),
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
                    return ItemSession(session: logic.list[index]);
                  },
                  itemCount: logic.list.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(height: 0, indent: 18.w, endIndent: 18.w));
            }));
  }
}
