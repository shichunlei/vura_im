import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vura/entities/user_entity.dart';
import 'package:vura/global/icon_font.dart';
import 'package:vura/modules/im/sessions/create/page.dart';
import 'package:vura/modules/im/sessions/join/page.dart';
import 'package:vura/route/route_path.dart';
import 'package:vura/utils/color_util.dart';
import 'package:vura/widgets/custom_icon_button.dart';
import 'package:vura/widgets/keep_alive_view.dart';
import 'package:vura/widgets/obx_widget.dart';

import 'logic.dart';

class SessionsPage extends StatelessWidget {
  const SessionsPage({super.key});

  SessionsLogic get logic => Get.find<SessionsLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: TabBar(
                dividerColor: Colors.white,
                dividerHeight: kToolbarHeight,
                tabAlignment: TabAlignment.fill,
                indicatorColor: Colors.transparent,
                labelColor: ColorUtil.color_333333,
                labelStyle: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                unselectedLabelStyle: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                unselectedLabelColor: const Color(0xffdddddd),
                tabs: const [Tab(text: "我创建的"), Tab(text: "我加入的")],
                controller: logic.tabController),
            centerTitle: true,
            actions: [
              CustomIconButton(
                  onPressed: () {
                    Get.toNamed(RoutePath.SELECT_CONTACTS_PAGE, arguments: {"isCheckBox": true})?.then((value) {
                      if (value != null && value is List<UserEntity>) logic.createSession(value);
                    });
                  },
                  icon: const Icon(IconFont.add_group, color: ColorUtil.color_333333))
            ]),
        body: BaseWidget(
            logic: logic,
            builder: (logic) {
              return TabBarView(controller: logic.tabController, children: const [
                KeepAliveView(child: MyCreateSessionsPage()),
                KeepAliveView(child: MyJoinSessionsPage())
              ]);
            }));
  }
}
