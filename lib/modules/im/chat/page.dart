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
import 'package:vura/widgets/custom_icon_button.dart';
import 'package:vura/widgets/obx_widget.dart';
import 'package:vura/widgets/radius_inkwell_widget.dart';

import 'logic.dart';

class ChatPage extends StatelessWidget {
  final String? tag;

  const ChatPage({super.key, this.tag});

  ChatLogic get logic => Get.find<ChatLogic>(tag: tag);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Obx(() {
              return Text(logic.session.value?.name ?? "聊天");
            }),
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
                                message: logic.list[index],
                                showTime: index == logic.list.length - 1 ||
                                    logic.list[index].sendTime - logic.list[index + 1].sendTime > 1000 * 60);
                          } else {
                            return ItemReceiveMessage(
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
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.only(topLeft: Radius.circular(20.r), topRight: Radius.circular(20.r))),
                        child: Column(mainAxisSize: MainAxisSize.min, children: [
                          Container(
                              margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                              height: 40.h,
                              child: Row(children: [
                                Expanded(
                                    child: Container(
                                        height: 40.h,
                                        alignment: Alignment.centerLeft,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(11.r), color: const Color(0xfff5f5f5)),
                                        child: TextField(
                                            controller: logic.controller,
                                            maxLines: 1,
                                            textInputAction: TextInputAction.send,
                                            style: GoogleFonts.roboto(fontSize: 13.sp, color: ColorUtil.color_333333),
                                            onSubmitted: (v) {
                                              DeviceUtils.hideKeyboard(context);
                                              logic.sendMessage(v, MessageType.TEXT);
                                            },
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
                                                hintText: "请输入您想说的话",
                                                hintStyle: GoogleFonts.roboto(
                                                    fontSize: 13.sp, color: ColorUtil.color_999999))))),
                                RadiusInkWellWidget(
                                    margin: EdgeInsets.only(left: 10.w),
                                    radius: 4.r,
                                    child: Container(
                                        width: 50.w,
                                        height: 30.h,
                                        alignment: Alignment.center,
                                        child: Text("发送",
                                            style: GoogleFonts.roboto(
                                                fontSize: 13.sp, color: Colors.white, fontWeight: FontWeight.w500))),
                                    onPressed: () {
                                      logic.sendMessage(logic.controller.text, MessageType.TEXT);
                                    })
                              ])),
                          const Divider(height: 0),
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 22.w),
                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                CustomIconButton(icon: const Icon(IconFont.voice), onPressed: () {}),
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
                                                          style:
                                                              TextStyle(fontWeight: FontWeight.w400, fontSize: 16.sp)),
                                                      onPressed: () {
                                                        Get.back();
                                                        logic.sendIdCard(Get.find<RootLogic>().user.value);
                                                      }),
                                                  CupertinoActionSheetAction(
                                                      child: Text("我的好友",
                                                          style:
                                                              TextStyle(fontWeight: FontWeight.w400, fontSize: 16.sp)),
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
                                          arguments: {Keys.ID: logic.id, Keys.TYPE: logic.type});
                                    }),
                                CustomIconButton(icon: const Icon(IconFont.expression), onPressed: () {})
                              ]))
                        ])))
              ]);
            }));
  }
}
