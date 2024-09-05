import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vura/modules/im/emoji/sub/list.dart';
import 'package:vura/widgets/keep_alive_view.dart';

import 'logic.dart';

class EmojiDialog extends StatelessWidget {
  const EmojiDialog({super.key});

  EmojiHomeLogic get logic => Get.put(EmojiHomeLogic());

  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20.r), topRight: Radius.circular(20.r))),
              child: Column(children: [
                Container(
                    alignment: Alignment.centerLeft,
                    height: 50.h,
                    child: Row(children: [
                      Expanded(
                          child: TabBar(
                              controller: logic.tabController,
                              dividerColor: Colors.white,
                              dividerHeight: kToolbarHeight,
                              tabAlignment: TabAlignment.start,
                              isScrollable: true,
                              tabs: [
                            Tab(child: Image.asset("assets/images/emoji_face.webp", width: 30.r, height: 30.r)),
                            Tab(child: Image.asset("assets/images/duck.webp", width: 30.r, height: 30.r)),
                            Tab(child: Image.asset("assets/images/fish.webp", width: 30.r, height: 30.r))
                          ])),
                      const CloseButton()
                    ])),
                const Divider(height: 0),
                SizedBox(
                    width: double.infinity,
                    height: 400.h,
                    child: TabBarView(controller: logic.tabController, children: const [
                      KeepAliveView(child: EmojiListView(tag: "normal")),
                      KeepAliveView(child: EmojiListView(tag: "duck")),
                      KeepAliveView(child: EmojiListView(tag: "fish"))
                    ]))
              ]))
        ]));
  }
}
