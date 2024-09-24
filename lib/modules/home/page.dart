import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vura/application.dart';
import 'package:vura/global/icon_font.dart';
import 'package:vura/modules/contacts/home/page.dart';
import 'package:vura/modules/dashboard/me/page.dart';
import 'package:vura/modules/im/session/page.dart';
import 'package:vura/modules/user/lock_screen_dialog/dialog.dart';
import 'package:vura/utils/color_util.dart';
import 'package:vura/utils/log_utils.dart';
import 'package:vura/widgets/widgets.dart';

import 'logic.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  HomeLogic get logic => Get.find<HomeLogic>();

  @override
  void initState() {
    super.initState();
    // 注册监听
    WidgetsBinding.instance.addObserver(this);
  }

  // 监听生命周期变化
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      // 应用进入后台
      Log.d("App进入后台====>${DateTime.now().toIso8601String()}");
      if (logic.loginProtect.value) logic.startTime.value ??= DateTime.now().millisecondsSinceEpoch;
    } else if (state == AppLifecycleState.resumed) {
      // 应用回到前台
      Log.d("App回到前台${DateTime.now().toIso8601String()}");

      webSocketManager.check();

      if (!logic.loginProtect.value) return;
      if (logic.startTime.value != null && DateTime.now().millisecondsSinceEpoch - logic.startTime.value! > 0) {
        Log.d(
            "在后台待了这么长时间=====================>${DateTime.now().millisecondsSinceEpoch - logic.startTime.value!}---------------------${logic.lockScreenTime.value}");
        if ((DateTime.now().millisecondsSinceEpoch - logic.startTime.value!) > logic.lockScreenTime.value) {
          Get.dialog(const LockScreenDialog(),
                  barrierDismissible: false, useSafeArea: false, barrierColor: Colors.white)
              .then((value) {
            if (value != null && value) logic.startTime.value = null;
          });
        } else {
          logic.startTime.value = null;
        }
      } else {
        logic.startTime.value = null;
      }
    } else if (state == AppLifecycleState.inactive) {
      Log.d("应用处于非活动状态");
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        onPopInvokedWithResult: (bool didPop, result) {
          if (didPop) return;
          if (logic.closeOnConfirm()) SystemNavigator.pop(); // 系统级别导航栈 退出程序
        },
        canPop: false, // 是否允许返回
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: ColorUtil.secondBgColor,
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
                            Text("message".tr,
                                style: GoogleFonts.roboto(
                                    fontSize: 11.sp, color: !isActive ? ColorUtil.color_999999 : ColorUtil.mainColor))
                          ])
                        : Column(mainAxisSize: MainAxisSize.min, children: [
                            SizedBox(height: 5.h),
                            Icon(isActive ? IconFont.tab_mine_selected : IconFont.tab_mine, size: 22),
                            Text("mine".tr,
                                style: GoogleFonts.roboto(
                                    fontSize: 11.sp, color: !isActive ? ColorUtil.color_999999 : ColorUtil.mainColor))
                          ]);
                  });
            })));
  }

  @override
  void dispose() {
    // 移除监听
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
