import 'package:extended_list/extended_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vura/global/config.dart';
import 'package:vura/global/enum.dart';
import 'package:vura/global/icon_font.dart';
import 'package:vura/global/keys.dart';
import 'package:vura/modules/im/widgets/item_receive_message.dart';
import 'package:vura/modules/im/widgets/item_send_message.dart';
import 'package:vura/modules/im/widgets/item_system_message.dart';
import 'package:vura/modules/root/logic.dart';
import 'package:vura/route/route_path.dart';
import 'package:vura/utils/color_util.dart';
import 'package:vura/utils/device_utils.dart';
import 'package:vura/utils/toast_util.dart';
import 'package:vura/widgets/custom_icon_button.dart';
import 'package:vura/widgets/obx_widget.dart';

import 'logic.dart';

class ChatPage extends StatelessWidget {
  final String? tag;

  const ChatPage({super.key, this.tag});

  ChatLogic get logic => Get.find<ChatLogic>(tag: tag);

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Stack(children: [
          Image.asset("assets/images/chat_bg_${logic.selectedBgIndex}.png",
              width: double.infinity, height: double.infinity, fit: BoxFit.fill),
          Scaffold(
              backgroundColor:
                  logic.selectedBgIndex == 0 ? Theme.of(context).scaffoldBackgroundColor : Colors.transparent,
              appBar: AppBar(
                  title: Obx(() {
                    return Text(logic.session.value?.name ?? "聊天");
                  }),
                  backgroundColor: logic.selectedBgIndex == 0 ? Colors.white : Colors.transparent,
                  centerTitle: true,
                  actions: [
                    CustomIconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: () {
                          if (logic.type == SessionType.private) {
                            Get.toNamed(RoutePath.PRIVATE_SESSION_DETAIL_PAGE, arguments: {Keys.ID: logic.id});
                          }
                          if (logic.type == SessionType.group) {
                            Get.toNamed(RoutePath.GROUP_SESSION_DETAIL_PAGE, arguments: {Keys.ID: logic.id});
                          }
                        })
                  ]),
              body: BaseWidget(
                  logic: logic,
                  showEmpty: false,
                  showError: false,
                  bgColor: Colors.transparent,
                  builder: (logic) {
                    return Column(children: [
                      Expanded(
                          child: ExtendedListView.separated(
                              physics: const BouncingScrollPhysics(),
                              padding: EdgeInsets.only(bottom: 15.h, left: 12.w, right: 12.w),
                              reverse: true,
                              itemBuilder: (_, index) {
                                if (logic.list[index].type == MessageType.TIP_TEXT.code) {
                                  return ItemSystemMessage(
                                      message: logic.list[index],
                                      showTime: index == logic.list.length - 1 ||
                                          logic.list[index].sendTime - logic.list[index + 1].sendTime > 1000 * 60);
                                }
                                if (logic.list[index].sendId == AppConfig.userId) {
                                  return ItemSendMessage(
                                      tag: tag,
                                      message: logic.list[index],
                                      showTime: index == logic.list.length - 1 ||
                                          logic.list[index].sendTime - logic.list[index + 1].sendTime > 1000 * 60);
                                } else {
                                  return ItemReceiveMessage(
                                      tag: tag,
                                      message: logic.list[index],
                                      showTime: index == logic.list.length - 1 ||
                                          logic.list[index].sendTime - logic.list[index + 1].sendTime > 1000 * 60);
                                }
                              },
                              separatorBuilder: (_, index) => SizedBox(height: 10.h),
                              itemCount: logic.list.length,
                              extendedListDelegate: const ExtendedListDelegate(closeToTrailing: true))),
                      SafeArea(
                          top: false,
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20.r), topRight: Radius.circular(20.r))),
                              child: Column(mainAxisSize: MainAxisSize.min, children: [
                                Container(
                                    margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                                    height: 50.h,
                                    child: Row(children: [
                                      Expanded(
                                          child: Container(
                                              height: 50.h,
                                              alignment: Alignment.centerLeft,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(11.r),
                                                  color: const Color(0xfff5f5f5)),
                                              child: TextField(
                                                  controller: logic.controller,
                                                  maxLines: 1,
                                                  textInputAction: TextInputAction.send,
                                                  style: GoogleFonts.roboto(
                                                      fontSize: 15.sp, color: ColorUtil.color_333333),
                                                  onSubmitted: (v) {
                                                    DeviceUtils.hideKeyboard();
                                                    logic.sendMessage(v, MessageType.TEXT);
                                                  },
                                                  decoration: InputDecoration(
                                                      contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
                                                      hintText: "请输入您想说的话",
                                                      border: InputBorder.none,
                                                      hintStyle: GoogleFonts.roboto(
                                                          fontSize: 15.sp, color: ColorUtil.color_999999))))),
                                      SizedBox(width: 10.w),
                                      CustomIconButton(
                                          bgColor: const Color(0xff2ECC72),
                                          icon: Icon(IconFont.send, color: Colors.white, size: 20.sp),
                                          radius: 25.h,
                                          onPressed: () {
                                            logic.sendMessage(logic.controller.text, MessageType.TEXT);
                                          })
                                    ])),
                                Divider(height: 0, color: logic.selectedBgIndex == 0 ? null : Colors.transparent),
                                Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 22.w),
                                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                      CustomIconButton(
                                          icon: const Icon(IconFont.voice),
                                          onPressed: () {
                                            showToast(text: "开发中。。。");
                                          }),
                                      CustomIconButton(
                                          icon: const Icon(IconFont.camera),
                                          onPressed: () {
                                            logic.getImage(ImageSource.camera);
                                          }),
                                      CustomIconButton(
                                          icon: const Icon(IconFont.name_card),
                                          onPressed: () {
                                            showCupertinoModalPopup(
                                                context: Get.context!,
                                                builder: (_) {
                                                  return CupertinoActionSheet(
                                                      actions: [
                                                        CupertinoActionSheetAction(
                                                            child: Text("我自己",
                                                                style: TextStyle(
                                                                    fontWeight: FontWeight.w400, fontSize: 16.sp)),
                                                            onPressed: () {
                                                              Get.back();
                                                              logic.sendIdCard(Get.find<RootLogic>().user.value);
                                                            }),
                                                        CupertinoActionSheetAction(
                                                            child: Text("我的好友",
                                                                style: TextStyle(
                                                                    fontWeight: FontWeight.w400, fontSize: 16.sp)),
                                                            onPressed: () {
                                                              Get.offNamed(RoutePath.SELECT_CONTACTS_PAGE,
                                                                  arguments: {"isCheckBox": false})?.then((value) {
                                                                if (value != null) logic.sendIdCard(value);
                                                              });
                                                            }),
                                                      ],
                                                      cancelButton: CupertinoActionSheetAction(
                                                          isDefaultAction: true,
                                                          onPressed: Get.back,
                                                          child: Text("取消", style: Get.theme.textTheme.bodyLarge)));
                                                });
                                          }),
                                      CustomIconButton(
                                          icon: const Icon(IconFont.gallery),
                                          onPressed: () {
                                            logic.getImage(ImageSource.gallery);
                                          }),
                                      CustomIconButton(
                                          icon: const Icon(IconFont.red_package),
                                          onPressed: () {
                                            Get.toNamed(RoutePath.PACKAGE_PUBLISH_PAGE,
                                                arguments: {Keys.ID: logic.id, Keys.TYPE: logic.type})?.then((value) {
                                              if (value != null) logic.sendRedPackage(value);
                                            });
                                          }),
                                      CustomIconButton(
                                          icon: const Icon(IconFont.expression),
                                          onPressed: () {
                                            ///
                                            showToast(text: "这是发什么？");
                                          })
                                    ]))
                              ])))
                    ]);
                  }))
        ]));
  }
}
