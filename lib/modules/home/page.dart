import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:im/global/icon_font.dart';
import 'package:im/widgets/frame_stack.dart';
import 'package:im/widgets/keep_alive_view.dart';

import 'contacts/page.dart';
import 'logic.dart';
import 'mine/page.dart';
import 'session/page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  HomeLogic get logic => Get.find<HomeLogic>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
        onPopInvoked: (bool didPop) {
          if (didPop) return;
          if (logic.closeOnConfirm()) SystemNavigator.pop(); // 系统级别导航栈 退出程序
        },
        canPop: false, // 是否允许返回
        child: Scaffold(
            backgroundColor: Colors.white,
            body: FrameStack(controller: logic.indexController, initIndex: 0, children: const [
              KeepAliveView(child: SessionPage()),
              KeepAliveView(child: ContactsPage()),
              KeepAliveView(child: MinePage())
            ]),
            floatingActionButton: FloatingActionButton(
                onPressed: () {
                  logic.onItemTapped(1);
                },
                child: const Icon(Icons.face, size: 22)),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: Obx(() {
              return BottomNavigationBar(
                  currentIndex: logic.selectedIndex.value,
                  fixedColor: Theme.of(context).primaryColor,
                  onTap: logic.onItemTapped,
                  items: const [
                    BottomNavigationBarItem(
                        icon: Icon(IconFont.tab_message, size: 22),
                        label: "消息",
                        activeIcon: Icon(IconFont.tab_message_selected, size: 22)),
                    BottomNavigationBarItem(
                        icon: Icon(IconFont.tab_message, size: 22),
                        label: "",
                        activeIcon: Icon(IconFont.tab_message_selected, size: 22)),
                    BottomNavigationBarItem(
                        icon: Icon(IconFont.tab_mine, size: 22),
                        label: "我的",
                        activeIcon: Icon(IconFont.tab_mine_selected, size: 22))
                  ],
                  type: BottomNavigationBarType.fixed,
                  unselectedFontSize: 10.sp,
                  selectedFontSize: 11.sp);
            })));
  }
}
