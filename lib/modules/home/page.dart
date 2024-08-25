import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:im/global/icon_font.dart';
import 'package:im/utils/color_util.dart';
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
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            body: FrameStack(controller: logic.indexController, initIndex: 0, children: const [
              KeepAliveView(child: SessionPage()),
              KeepAliveView(child: MinePage()),
              KeepAliveView(child: ContactsPage())
            ]),
            floatingActionButton: FloatingActionButton(
                backgroundColor: const Color(0xffFFAE58),
                shape: const CircleBorder(),
                onPressed: () {
                  logic.onItemTapped(2);
                },
                child: Obx(() {
                  return Icon(logic.selectedIndex.value == 2 ? IconFont.tab_contacts_fill : IconFont.tab_contacts_line,
                      size: 26, color: Colors.white);
                })),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: Obx(() {
              return AnimatedBottomNavigationBar.builder(
                  activeIndex: logic.selectedIndex.value,
                  gapLocation: GapLocation.center,
                  notchSmoothness: NotchSmoothness.softEdge,
                  splashColor: Colors.white,
                  onTap: logic.onItemTapped,
                  itemCount: 2,
                  elevation: 8,
                  leftCornerRadius: 20,
                  rightCornerRadius: 20,
                  backgroundColor: Colors.white,
                  tabBuilder: (int index, bool isActive) {
                    return index == 0
                        ? Column(mainAxisSize: MainAxisSize.min, children: [
                            SizedBox(height: 5.h),
                            Icon(isActive ? IconFont.tab_message_selected : IconFont.tab_message, size: 22),
                            Text("消息",
                                style: GoogleFonts.roboto(
                                    fontSize: 11.sp,
                                    color: !isActive ? ColorUtil.color_999999 : const Color(0xff83C240)))
                          ])
                        : Column(mainAxisSize: MainAxisSize.min, children: [
                            SizedBox(height: 5.h),
                            Icon(isActive ? IconFont.tab_mine_selected : IconFont.tab_mine, size: 22),
                            Text("我的",
                                style: GoogleFonts.roboto(
                                    fontSize: 11.sp,
                                    color: !isActive ? ColorUtil.color_999999 : const Color(0xff83C240)))
                          ]);
                  });
            })));
  }
}
