import 'package:azlistview_plus/azlistview_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vura/entities/user_entity.dart';
import 'package:vura/global/icon_font.dart';
import 'package:vura/route/route_path.dart';
import 'package:vura/utils/color_util.dart';
import 'package:vura/utils/permission_util.dart';
import 'package:vura/utils/toast_util.dart';
import 'package:vura/widgets/avatar_image.dart';
import 'package:vura/widgets/custom_icon_button.dart';
import 'package:vura/widgets/obx_widget.dart';
import 'package:vura/widgets/radius_inkwell_widget.dart';
import 'package:vura/widgets/state_view/empty_page.dart';
import 'package:vura/widgets/state_view/loading_widget.dart';

import 'logic.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  ContactsLogic get logic => Get.find<ContactsLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorUtil.secondBgColor,
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text("contacts".tr),
            actions: [
              CustomIconButton(
                  icon: const Icon(IconFont.search),
                  onPressed: () async {
                    if (await PermissionUtil.checkContactsPermissionStatus(context)) {
                      Get.toNamed(RoutePath.PHONE_CONTACTS_PAGE);
                    } else {
                      showToast(text: '请先打开访问通讯录权限');
                    }
                  })
            ],
            centerTitle: false),
        body: BaseWidget(
            logic: logic,
            showLoading: false,
            showEmpty: false,
            showError: false,
            bgColor: Colors.transparent,
            builder: (logic) {
              return Column(children: [
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 36.w),
                    height: 120.h,
                    child: Row(children: [
                      Column(mainAxisSize: MainAxisSize.min, children: [
                        RadiusInkWellWidget(
                            radius: 66,
                            colors: const [Color(0xffF09A6F), Color(0xffED746B)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            onPressed: () {
                              Get.toNamed(RoutePath.ADD_FRIEND_PAGE);
                            },
                            margin: EdgeInsets.only(bottom: 7.h),
                            child: Container(
                                height: 66.r,
                                width: 66.r,
                                alignment: Alignment.center,
                                child: Icon(IconFont.add_friend, color: Colors.white, size: 35.r))),
                        Text("Add friends".tr,
                            style: GoogleFonts.dmSans(color: ColorUtil.color_333333, fontSize: 13.sp))
                      ]),
                      const Spacer(),
                      Column(mainAxisSize: MainAxisSize.min, children: [
                        RadiusInkWellWidget(
                            radius: 66,
                            colors: const [Color(0xffF7D147), Color(0xffF2AF3D)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            onPressed: () {
                              Get.toNamed(RoutePath.BLACKLIST_PAGE);
                            },
                            margin: EdgeInsets.only(bottom: 7.h),
                            child: Container(
                                height: 66.r,
                                width: 66.r,
                                alignment: Alignment.center,
                                child: Icon(IconFont.black_list, color: Colors.white, size: 35.r))),
                        Text('blacklist'.tr, style: GoogleFonts.dmSans(color: ColorUtil.color_333333, fontSize: 13.sp))
                      ]),
                      const Spacer(),
                      Column(mainAxisSize: MainAxisSize.min, children: [
                        RadiusInkWellWidget(
                            radius: 66,
                            colors: const [Color(0xffA293F7), Color(0xff7971DC)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            onPressed: () {
                              Get.toNamed(RoutePath.NEW_FRIEND_PAGE);
                            },
                            margin: EdgeInsets.only(bottom: 7.h),
                            child: Container(
                                height: 66.r,
                                width: 66.r,
                                alignment: Alignment.center,
                                child: Icon(IconFont.new_friend, color: Colors.white, size: 35.r))),
                        Text("New friends".tr,
                            style: GoogleFonts.dmSans(color: ColorUtil.color_333333, fontSize: 13.sp))
                      ])
                    ])),
                Expanded(
                    child: logic.busy
                        ? const LoadingWidget(bgColor: Colors.transparent)
                        : logic.empty || logic.list.isEmpty
                            ? const EmptyPage(bgColor: Colors.transparent)
                            : AzListView(
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
      GestureDetector(
          onTap: () {
            logic.goChatPage(user);
          },
          behavior: HitTestBehavior.translucent,
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: 11.h),
              child: Row(children: [
                SizedBox(width: 22.w),
                AvatarImageView("${user.headImage}", radius: 26.r, name: user.nickName),
                SizedBox(width: 18.w),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${user.nickName}",
                          style: GoogleFonts.roboto(
                              fontSize: 18.sp, color: ColorUtil.color_333333, fontWeight: FontWeight.w500)),
                      SizedBox(height: 5.r),
                      Text("一天前在线", style: GoogleFonts.roboto(fontSize: 11.sp, color: ColorUtil.color_999999))
                    ],
                  ),
                )
              ])))
    ]);
  }
}
