import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:im/global/icon_font.dart';
import 'package:im/modules/sessions/create/page.dart';
import 'package:im/modules/sessions/join/page.dart';
import 'package:im/utils/color_util.dart';
import 'package:im/widgets/keep_alive_view.dart';
import 'package:im/widgets/obx_widget.dart';

import 'logic.dart';

class SessionsPage extends StatelessWidget {
  const SessionsPage({super.key});

  SessionsLogic get logic => Get.find<SessionsLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: TabBar(tabs: const [Tab(text: "我创建的"), Tab(text: "我加入的")], controller: logic.tabController),
            centerTitle: true,
            actions: [
              IconButton(onPressed: () {}, icon: const Icon(IconFont.add_square, color: ColorUtil.color_333333))
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
