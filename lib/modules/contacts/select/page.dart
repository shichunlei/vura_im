import 'package:azlistview_plus/azlistview_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vura/entities/user_entity.dart';
import 'package:vura/utils/color_util.dart';
import 'package:vura/widgets/appbar_bottom_search_view.dart';
import 'package:vura/widgets/avatar_image.dart';
import 'package:vura/widgets/obx_widget.dart';

import 'logic.dart';

class SelectContactsPage extends StatelessWidget {
  const SelectContactsPage({super.key});

  SelectContactsLogic get logic => Get.find<SelectContactsLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            actions: logic.isCheckBox
                ? [
                    Center(child: Obx(() {
                      return TextButton(
                          onPressed: logic.selectUsers.isNotEmpty
                              ? () {
                                  Get.back(result: logic.selectUsers);
                                }
                              : null,
                          child: Obx(() {
                            return Text(logic.selectUsers.isNotEmpty ? "确定(${logic.selectUsers.length}人)" : "确定");
                          }));
                    }))
                  ]
                : [],
            title: const Text("选择联系人"),
            centerTitle: true,
            bottom: AppBarBottomSearchView(onSubmitted: logic.search, onChanged: logic.search, hintText: "搜索")),
        body: BaseWidget(
            logic: logic,
            showEmpty: false,
            showError: false,
            builder: (logic) {
              return Column(children: [
                logic.selectUsers.isEmpty
                    ? const SizedBox()
                    : Container(
                        padding: EdgeInsets.symmetric(horizontal: 22.w),
                        alignment: Alignment.centerLeft,
                        height: 60.r,
                        child: ListView.separated(
                            itemBuilder: (_, index) {
                              return AvatarRoundImage("${logic.selectUsers[index].headImage}",
                                  height: 44.r, width: 44.r, radius: 4.r, name: logic.selectUsers[index].nickName);
                            },
                            itemCount: logic.selectUsers.length,
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.symmetric(vertical: 8.r),
                            separatorBuilder: (BuildContext context, int index) => SizedBox(width: 10.w))),
                Expanded(
                    child: AzListView(
                        data: logic.list,
                        itemCount: logic.list.length,
                        itemBuilder: (_, index) => _buildListItem(logic.list[index]),
                        padding: EdgeInsets.zero,
                        indexBarData: const ['★', ...kIndexBarData],
                        indexBarOptions: IndexBarOptions(
                            needRebuild: true,
                            ignoreDragCancel: true,
                            downTextStyle: TextStyle(fontSize: 12.sp, color: Colors.white),
                            downItemDecoration:
                                BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).primaryColor),
                            indexHintWidth: 60,
                            indexHintHeight: 60,
                            indexHintDecoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("assets/images/index_bar.png"), fit: BoxFit.contain)),
                            indexHintAlignment: Alignment.centerRight,
                            indexHintChildAlignment: const Alignment(-0.25, 0.0),
                            indexHintOffset: const Offset(-20, 0))))
              ]);
            }));
  }

  // 头部
  Widget buildSuspensionTag(String susTag) {
    return Column(children: [
      SizedBox(height: 5.h),
      const Divider(height: 0),
      SizedBox(height: 8.h),
      Container(
          padding: EdgeInsets.symmetric(horizontal: 22.w),
          height: 30.h,
          width: double.infinity,
          alignment: Alignment.centerLeft,
          child: Text(susTag))
    ]);
  }

  // item
  Widget _buildListItem(UserEntity user) {
    String susTag = user.getSuspensionTag();

    return Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
      Offstage(offstage: !user.isShowSuspension, child: buildSuspensionTag(susTag)),
      Padding(
          padding: EdgeInsets.symmetric(vertical: 11.h),
          child: GestureDetector(
              onTap: () {
                if (logic.isCheckBox) {
                  if (logic.selectUserIds.any((item) => item == user.id)) return;
                  if (logic.selectUsers.any((item) => item.id == user.id)) {
                    logic.selectUsers.removeWhere((item) => item.id == user.id);
                  } else {
                    logic.selectUsers.add(user);
                  }
                  logic.selectUsers.refresh();
                } else {
                  Get.back(result: user);
                }
              },
              behavior: HitTestBehavior.translucent,
              child: Row(children: [
                SizedBox(width: 22.w),
                logic.isCheckBox
                    ? Obx(() {
                        return Icon(
                            logic.selectUsers.any((item) => item.id == user.id) ||
                                    logic.selectUserIds.any((item) => item == user.id)
                                ? Icons.check_circle
                                : Icons.circle_outlined,
                            color: logic.selectUsers.any((item) => item.id == user.id)
                                ? Theme.of(Get.context!).primaryColor
                                : logic.selectUserIds.any((item) => item == user.id)
                                    ? Theme.of(Get.context!).primaryColor.withOpacity(.5)
                                    : const Color(0xffdddddd),
                            size: 10.r);
                      })
                    : const SizedBox(),
                SizedBox(width: 12.w),
                AvatarImageView("${user.headImage}", radius: 26.r, name: user.nickName),
                SizedBox(width: 18.w),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${user.nickName ?? user.userName}",
                          style: GoogleFonts.roboto(
                              fontSize: 18.sp, color: ColorUtil.color_333333, fontWeight: FontWeight.w500)),
                      SizedBox(height: 5.r),
                      Text("ID:${user.id}", style: GoogleFonts.roboto(fontSize: 11.sp, color: ColorUtil.color_999999))
                    ],
                  ),
                )
              ])))
    ]);
  }
}
