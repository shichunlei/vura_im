import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vura/widgets/obx_widget.dart';

import 'logic.dart';

class EmojiListView extends StatelessWidget {
  final String? tag;

  const EmojiListView({super.key, this.tag});

  EmojiLogic get logic => Get.find<EmojiLogic>(tag: tag);

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.white,
        child: BaseWidget(
            logic: logic,
            builder: (logic) {
              return GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 11.h),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: logic.type == "normal" ? 8 : 5, mainAxisSpacing: 5.r, crossAxisSpacing: 5.r),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                        onTap: () {
                          Get.back(result: logic.list[index]);
                        },
                        behavior: HitTestBehavior.translucent,
                        child: Image.asset("assets/images/emoji_${logic.list[index].type}/${logic.list[index].path}"));
                  },
                  itemCount: logic.list.length);
            }));
  }
}
