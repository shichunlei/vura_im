import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vura/global/icon_font.dart';
import 'package:vura/utils/color_util.dart';
import 'package:vura/widgets/obx_widget.dart';
import 'package:vura/widgets/radius_inkwell_widget.dart';

import 'logic.dart';

class LinePage extends StatelessWidget {
  const LinePage({super.key});

  LineLogic get logic => Get.find<LineLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("线路管理"), centerTitle: true),
        body: BaseWidget(
            logic: logic,
            builder: (logic) {
              return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 22.h),
                  child: Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(11.r), color: Colors.white),
                      child: ListView.separated(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (_, index) {
                            return RadiusInkWellWidget(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(index == 0 ? 11.r : 0),
                                    topLeft: Radius.circular(index == 0 ? 11.r : 0),
                                    bottomLeft: Radius.circular(index == logic.list.length - 1 ? 11.r : 0),
                                    bottomRight: Radius.circular(index == logic.list.length - 1 ? 11.r : 0)),
                                padding: EdgeInsets.only(left: 22.w, right: 30.w),
                                onPressed: () {
                                  logic.selectIndex.value = index;
                                },
                                child: SizedBox(
                                    height: 60.h,
                                    child: Row(children: [
                                      Text("线路${index + 1}",
                                          style: GoogleFonts.roboto(
                                              fontSize: 15.sp,
                                              color: ColorUtil.color_333333,
                                              fontWeight: FontWeight.bold)),
                                      const Spacer(),
                                      Obx(() {
                                        return Visibility(
                                            visible: logic.selectIndex.value == index,
                                            child: Icon(IconFont.check, size: 15.r));
                                      })
                                    ])));
                          },
                          separatorBuilder: (_, index) {
                            return Divider(indent: 22.w, endIndent: 22.w, height: 0);
                          },
                          itemCount: logic.list.length)));
            }));
  }
}
