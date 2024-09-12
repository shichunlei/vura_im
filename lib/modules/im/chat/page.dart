import 'dart:convert';

import 'package:emoji_picker/emoji_picker.dart';
import 'package:extended_list/extended_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vura/entities/member_entity.dart';
import 'package:vura/global/config.dart';
import 'package:vura/global/enum.dart';
import 'package:vura/global/icon_font.dart';
import 'package:vura/global/keys.dart';
import 'package:vura/modules/im/at/dialog.dart';
import 'package:vura/modules/im/widgets/item_receive_message.dart';
import 'package:vura/modules/im/widgets/item_send_message.dart';
import 'package:vura/modules/im/widgets/item_system_message.dart';
import 'package:vura/modules/root/logic.dart';
import 'package:vura/route/route_path.dart';
import 'package:vura/utils/color_util.dart';
import 'package:vura/utils/device_utils.dart';
import 'package:vura/utils/log_utils.dart';
import 'package:vura/utils/string_util.dart';
import 'package:vura/widgets/custom_icon_button.dart';
import 'package:vura/widgets/obx_widget.dart';
import 'package:vura/widgets/voice_record_view.dart';

import 'logic.dart';

class ChatPage extends StatelessWidget {
  final String? tag;

  const ChatPage({super.key, this.tag});

  ChatLogic get logic => Get.find<ChatLogic>(tag: tag);

  @override
  Widget build(BuildContext context) {
    return Material(
        color: ColorUtil.secondBgColor,
        child: Stack(children: [
          logic.selectedBgIndex == 0
              ? const SizedBox()
              : Image.asset("assets/images/chat_bg_${logic.selectedBgIndex}.png",
                  width: double.infinity, height: double.infinity, fit: BoxFit.fill),
          Scaffold(
              backgroundColor: logic.selectedBgIndex == 0 ? ColorUtil.secondBgColor : Colors.transparent,
              appBar: AppBar(
                  title: Obx(() {
                    return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(logic.session.value?.name ?? "聊天"),
                          Visibility(
                              visible:
                                  logic.type == SessionType.private && StringUtil.isNotEmpty(logic.session.value?.name),
                              child: Text("一分钟前在线",
                                  style: GoogleFonts.roboto(color: ColorUtil.color_999999, fontSize: 10.sp)))
                        ]);
                  }),
                  backgroundColor: logic.selectedBgIndex == 0 ? ColorUtil.secondBgColor : Colors.transparent,
                  centerTitle: true,
                  actions: [
                    Obx(() {
                      return Visibility(
                          visible:
                              !(logic.members.every((item) => item.userId != Get.find<RootLogic>().user.value?.id) &&
                                      logic.type == SessionType.group) ||
                                  logic.type == SessionType.private,
                          child: CustomIconButton(
                              icon: const Icon(Icons.more_vert),
                              onPressed: () {
                                DeviceUtils.hideKeyboard(context);
                                if (logic.type == SessionType.private) {
                                  Get.toNamed(RoutePath.PRIVATE_SESSION_DETAIL_PAGE, arguments: {Keys.ID: logic.id});
                                }
                                if (logic.type == SessionType.group) {
                                  Get.toNamed(RoutePath.GROUP_SESSION_DETAIL_PAGE, arguments: {Keys.ID: logic.id});
                                }
                              }));
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
                      Obx(() => logic.session.value != null
                          ? SafeArea(
                              top: false,
                              child: logic.type == SessionType.group &&
                                      logic.members.isNotEmpty &&
                                      logic.members.every((item) => item.userId != Get.find<RootLogic>().user.value?.id)
                                  ? Container(
                                      margin: EdgeInsets.only(bottom: 11.h, left: 22.w, right: 22.w),
                                      height: 50.h,
                                      decoration: BoxDecoration(
                                          color: const Color(0xfff5f5f5), borderRadius: BorderRadius.circular(20.r)),
                                      alignment: Alignment.center,
                                      child: Text("已经被移除出群聊...",
                                          style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_333333)))
                                  : logic.type == SessionType.group &&
                                          logic.members.isNotEmpty &&
                                          (logic.session.value?.configObj?.allMute == YorNType.Y &&
                                                  logic.session.value?.isAdmin == YorNType.N &&
                                                  logic.session.value?.isSupAdmin == YorNType.N // 全体禁言后，只有群主和群管理员可以发言
                                              ||
                                              logic.members
                                                      .firstWhere(
                                                          (item) => item.userId == Get.find<RootLogic>().user.value?.id)
                                                      .isMute ==
                                                  YorNType.Y // 被单独设置为禁言
                                          )
                                      ? Container(
                                          margin: EdgeInsets.only(bottom: 11.h, left: 22.w, right: 22.w),
                                          height: 50.h,
                                          decoration: BoxDecoration(
                                              color: const Color(0xfff5f5f5),
                                              borderRadius: BorderRadius.circular(20.r)),
                                          alignment: Alignment.center,
                                          child: Text("禁言中...",
                                              style:
                                                  GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_333333)))
                                      : Container(
                                          decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(20.r), topRight: Radius.circular(20.r))),
                                          child: Column(mainAxisSize: MainAxisSize.min, children: [
                                            logic.isVoice.value
                                                ? Container(
                                                    margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                                                    height: 50.h,
                                                    child: VoiceRecordWidget(
                                                        height: 42.w,
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(21.w),
                                                            color: Colors.white),
                                                        margin: EdgeInsets.symmetric(horizontal: 7.w),
                                                        startRecord: () {
                                                          Log.d('开始录制');
                                                        },
                                                        stopRecord:
                                                            (String? path, double? audioTimeLength, bool isCancel) {
                                                          Log.d('结束录制 ====》 $isCancel');
                                                          Log.d('路径 ====》 $path');
                                                          Log.d('时长 ====》 $audioTimeLength');
                                                          if (!isCancel) {
                                                            logic.uploadAudio(path, (audioTimeLength! * 1000).toInt());
                                                          }
                                                        }))
                                                : Container(
                                                    margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                                                    height: 50.h,
                                                    child: Row(children: [
                                                      Expanded(
                                                          child: Container(
                                                              height: 50.h,
                                                              alignment: Alignment.centerLeft,
                                                              decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(11.r),
                                                                  color: Colors.white),
                                                              child: TextField(
                                                                  controller: logic.controller,
                                                                  maxLines: 1,
                                                                  textInputAction: TextInputAction.send,
                                                                  style: GoogleFonts.roboto(
                                                                      fontSize: 15.sp, color: ColorUtil.color_333333),
                                                                  onSubmitted: (v) {
                                                                    DeviceUtils.hideKeyboard(context);
                                                                    logic.sendMessage(v, MessageType.TEXT);
                                                                  },
                                                                  onChanged: (value) {
                                                                    if (logic.type == SessionType.group &&
                                                                        value.endsWith("@")) {
                                                                      DeviceUtils.hideKeyboard(context);
                                                                      Get.bottomSheet(
                                                                              SelectAtMemberDialog(
                                                                                  members: logic.members
                                                                                      .where((item) =>
                                                                                          item.userId !=
                                                                                          Get.find<RootLogic>()
                                                                                              .user
                                                                                              .value
                                                                                              ?.id)
                                                                                      .toList()),
                                                                              clipBehavior: Clip.antiAlias,
                                                                              shape: RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.only(
                                                                                      topLeft: Radius.circular(15.r),
                                                                                      topRight: Radius.circular(15.r))),
                                                                              isScrollControlled: true)
                                                                          .then((value) {
                                                                        if (value != null && value.isNotEmpty) {
                                                                          logic.controller.text =
                                                                              "${logic.controller.text.substring(0, logic.controller.text.length - 1)}${(value as List<MemberEntity>).map((item) => "@${item.showNickName}").toList().join(" ")} ";
                                                                        }
                                                                      });
                                                                    }
                                                                  },
                                                                  decoration: InputDecoration(
                                                                      contentPadding:
                                                                          EdgeInsets.symmetric(horizontal: 10.w),
                                                                      hintText: "请输入您想说的话",
                                                                      border: InputBorder.none,
                                                                      hintStyle: GoogleFonts.roboto(
                                                                          fontSize: 15.sp,
                                                                          color: ColorUtil.color_999999))))),
                                                      SizedBox(width: 10.w),
                                                      CustomIconButton(
                                                          bgColor: const Color(0xff2ECC72),
                                                          icon: Icon(IconFont.send, color: Colors.white, size: 20.sp),
                                                          radius: 25.h,
                                                          onPressed: () {
                                                            logic.sendMessage(logic.controller.text, MessageType.TEXT);
                                                          })
                                                    ])),
                                            Divider(
                                                height: 0,
                                                color: logic.selectedBgIndex == 0 ? null : Colors.transparent),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 18.w,
                                                  top: 11.h,
                                                  right: 18.w,
                                                  bottom: DeviceUtils.bottomSafeHeight > 0
                                                      ? 11.h
                                                      : DeviceUtils.bottomSafeHeight + 22.h),
                                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                GestureDetector(
                                                    behavior: HitTestBehavior.translucent,
                                                    onTap: logic.isVoice.toggle,
                                                    child: SvgPicture.asset("assets/svg/voice.svg")),
                                                GestureDetector(
                                                    behavior: HitTestBehavior.translucent,
                                                    onTap: () {
                                                      logic.isVoice.value = false;
                                                      logic.getImage(ImageSource.camera);
                                                    },
                                                    child: SvgPicture.asset("assets/svg/camera.svg")),
                                                GestureDetector(
                                                    behavior: HitTestBehavior.translucent,
                                                    child: SvgPicture.asset("assets/svg/id_card.svg"),
                                                    onTap: () {
                                                      logic.isVoice.value = false;
                                                      showCupertinoModalPopup(
                                                          context: Get.context!,
                                                          builder: (_) {
                                                            return CupertinoActionSheet(
                                                                actions: [
                                                                  CupertinoActionSheetAction(
                                                                      child: Text("我自己",
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w400,
                                                                              fontSize: 16.sp)),
                                                                      onPressed: () {
                                                                        Get.back();
                                                                        logic.sendIdCard(
                                                                            Get.find<RootLogic>().user.value);
                                                                      }),
                                                                  CupertinoActionSheetAction(
                                                                      child: Text("我的好友",
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w400,
                                                                              fontSize: 16.sp)),
                                                                      onPressed: () {
                                                                        Get.offNamed(RoutePath.SELECT_CONTACTS_PAGE,
                                                                                arguments: {"isCheckBox": false})
                                                                            ?.then((value) {
                                                                          if (value != null) logic.sendIdCard(value);
                                                                        });
                                                                      }),
                                                                ],
                                                                cancelButton: CupertinoActionSheetAction(
                                                                    isDefaultAction: true,
                                                                    onPressed: Get.back,
                                                                    child: Text("Cancel".tr,
                                                                        style: Get.theme.textTheme.bodyLarge)));
                                                          });
                                                    }),
                                                GestureDetector(
                                                    behavior: HitTestBehavior.translucent,
                                                    child: SvgPicture.asset("assets/svg/gallery.svg"),
                                                    onTap: () {
                                                      logic.isVoice.value = false;
                                                      logic.getImage(ImageSource.gallery);
                                                    }),
                                                GestureDetector(
                                                    behavior: HitTestBehavior.translucent,
                                                    child: SvgPicture.asset("assets/svg/red_package.svg"),
                                                    onTap: () {
                                                      logic.isVoice.value = false;
                                                      Get.toNamed(RoutePath.PACKAGE_PUBLISH_PAGE,
                                                              arguments: {Keys.ID: logic.id, Keys.TYPE: logic.type})
                                                          ?.then((value) {
                                                        if (value != null) logic.sendRedPackage(value);
                                                      });
                                                    }),
                                                GestureDetector(
                                                    behavior: HitTestBehavior.translucent,
                                                    child: SvgPicture.asset("assets/svg/emoji.svg"),
                                                    onTap: () {
                                                      logic.isVoice.value = false;
                                                      Get.bottomSheet(const EmojiPickerDialog()).then((value) {
                                                        if (value != null) {
                                                          Log.d(value.toJson());
                                                          logic.sendMessage(
                                                              json.encode(value.toJson()), MessageType.EMOJI);
                                                        }
                                                      });
                                                    })
                                              ]),
                                            )
                                          ])))
                          : const SizedBox())
                    ]);
                  }))
        ]));
  }
}
