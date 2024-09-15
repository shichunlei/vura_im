import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vura/entities/emoji.dart';
import 'package:vura/entities/file_entity.dart';
import 'package:vura/entities/message_entity.dart';
import 'package:vura/entities/package_entity.dart';
import 'package:vura/entities/user_entity.dart';
import 'package:vura/global/enum.dart';
import 'package:vura/global/icon_font.dart';
import 'package:vura/global/keys.dart';
import 'package:vura/modules/im/chat/logic.dart';
import 'package:vura/modules/root/logic.dart';
import 'package:vura/route/route_path.dart';
import 'package:vura/utils/color_util.dart';
import 'package:vura/utils/date_util.dart';
import 'package:vura/utils/device_utils.dart';
import 'package:vura/utils/log_utils.dart';
import 'package:vura/utils/string_util.dart';
import 'package:vura/utils/toast_util.dart';
import 'package:vura/widgets/widgets.dart';

import 'item_receive_card.dart';
import 'item_receive_emoji.dart';
import 'item_receive_image.dart';
import 'item_receive_red_package.dart';
import 'item_receive_text.dart';
import 'item_receive_voice.dart';

class ItemReceiveMessage extends StatelessWidget {
  final MessageEntity message;
  final bool showTime;
  final String? tag;

  const ItemReceiveMessage({super.key, required this.message, this.showTime = false, this.tag});

  ChatLogic get logic => Get.find<ChatLogic>(tag: tag);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Visibility(
          visible: showTime,
          child: Container(
              height: 30.h,
              alignment: Alignment.center,
              child: Text(DateUtil.getWechatTime(message.sendTime),
                  style: GoogleFonts.roboto(color: ColorUtil.color_666666, fontSize: 13.sp)))),
      SizedBox(height: 5.h),
      Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
        AvatarImageView("${message.sendHeadImage}",
            radius: 22.r,
            name: "${message.sendNickName}",
            onTap: logic.type == SessionType.group &&
                    logic.members.any((item) => item.userId == message.sendId) &&
                    logic.members.any((item) => item.userId == Get.find<RootLogic>().user.value?.id)
                ? () {
                    DeviceUtils.hideKeyboard(context);
                    Get.dialog(customDialog(
                        logic.session.value?.isAdmin == YorNType.Y || logic.session.value?.isSupAdmin == YorNType.Y,
                        message.sendId,
                        message.sendNickName));
                  }
                : () {
                    Log.d("22222222222222222222222");
                  }),
        SizedBox(width: 8.w),
        buildMessageView(message.type)
      ])
    ]);
  }

  Widget buildMessageView(int type) {
    if (type == MessageType.TEXT.code) return ItemReceiveText(message: message);
    if (type == MessageType.IMAGE.code && StringUtil.isNotEmpty(message.content)) {
      return ItemReceiveImage(message: message, file: ImageEntity.fromJson(json.decode(message.content!)));
    }
    if (type == MessageType.ID_CARD.code && StringUtil.isNotEmpty(message.content)) {
      return ItemReceiveCard(message: message, user: UserEntity.fromJson(json.decode(message.content!)));
    }
    if (type == MessageType.EMOJI.code && message.content != null) {
      return ItemReceiveEmoji(message: message, emoji: EmojiEntity.fromJson(json.decode(message.content!)));
    }
    if (type == MessageType.AUDIO.code && message.content != null) {
      return ItemReceiveVoice(message: message, tag: tag, file: AudioEntity.fromJson(json.decode(message.content!)));
    }
    if ((type == MessageType.RED_PACKAGE.code || type == MessageType.GROUP_RED_PACKAGE.code) &&
        message.content != null) {
      return ItemReceiveRedPackage(
          message: message, tag: tag, redPackage: RedPackageEntity.fromJson(json.decode(message.content!)));
    }
    return Text("暂未适配的消息类型${message.content}");
  }

  Widget customDialog(bool isManager, String? userId, String? userName) {
    return Material(
        type: MaterialType.transparency,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r), color: Get.theme.cardColor),
              width: 250.w,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topRight: Radius.circular(8.r), topLeft: Radius.circular(8.r))),
                    height: 40.h,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: 22.w),
                    child: Text("$userName")),
                RadiusInkWellWidget(
                    radius: 0,
                    color: Colors.transparent,
                    onPressed: () {
                      Get.back();
                      if (logic.type == SessionType.group &&
                          logic.members.isNotEmpty &&
                          (logic.session.value?.configObj?.allMute == YorNType.Y &&
                                  logic.session.value?.isAdmin == YorNType.N &&
                                  logic.session.value?.isSupAdmin == YorNType.N // 全体禁言后，只有群主和群管理员可以发言
                              ||
                              logic.members
                                      .firstWhere((item) => item.userId == Get.find<RootLogic>().user.value?.id)
                                      .isMute ==
                                  YorNType.Y // 被单独设置为禁言
                          )) {
                        showToast(text: "您被禁言");
                        return;
                      }
                      logic.atUserIds.add(message.sendId);
                      // logic.sendMessage("@${message.sendNickName}", MessageType.TEXT, ids: [message.sendId]);
                      logic.controller.text =
                          "@${logic.members.firstWhere((item) => item.userId == message.sendId).showNickName} ";
                      logic.focusNode.requestFocus(); // 获取焦点
                    },
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 22.w),
                        height: 50.h,
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: Row(children: [
                          Text("@TA",
                              style: TextStyle(
                                  fontSize: 16.sp, fontWeight: FontWeight.w600, color: ColorUtil.color_333333)),
                          const Spacer(),
                          const Icon(IconFont.at, color: ColorUtil.color_333333)
                        ]))),
                ...logic.members.any((item) => item.userId == message.sendId) &&
                        logic.members.firstWhere((item) => item.userId == message.sendId).friendship == YorNType.Y
                    ? [
                        const Divider(height: .5),
                        RadiusInkWellWidget(
                            radius: 0,
                            borderRadius: isManager
                                ? null
                                : BorderRadius.only(
                                    bottomRight: Radius.circular(8.r), bottomLeft: Radius.circular(8.r)),
                            color: Colors.transparent,
                            child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 22.w),
                                height: 50.h,
                                width: double.infinity,
                                alignment: Alignment.center,
                                child: Row(children: [
                                  Text("向TA转账", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
                                  const Spacer(),
                                  const Icon(IconFont.transfer_to_member, color: ColorUtil.color_333333)
                                ])),
                            onPressed: () {
                              UserEntity toUser = UserEntity(
                                  nickName: message.sendNickName,
                                  id: message.sendId,
                                  headImageThumb: message.sendHeadImage,
                                  headImage: message.sendHeadImage);

                              Get.offNamed(RoutePath.PACKAGE_PUBLISH_PAGE, arguments: {
                                Keys.ID: toUser.id,
                                Keys.TYPE: SessionType.private,
                                "user": toUser,
                                "isTransfer": true
                              })?.then((value) {
                                if (value != null) {
                                  logic.transferToMember(value, toUser);
                                }
                              });
                            })
                      ]
                    : [],
                ...isManager
                    ? [
                        const Divider(height: .5),
                        RadiusInkWellWidget(
                            radius: 0,
                            color: Colors.transparent,
                            child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 22.w),
                                height: 50.h,
                                width: double.infinity,
                                alignment: Alignment.center,
                                child: Row(children: [
                                  Text(
                                      logic.members.firstWhere((item) => item.userId == userId).isMute == YorNType.Y
                                          ? "解除禁言TA"
                                          : "禁言TA",
                                      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
                                  const Spacer(),
                                  const Icon(IconFont.mute, color: ColorUtil.color_333333)
                                ])),
                            onPressed: () {
                              Get.back();
                              if (logic.members.firstWhere((item) => item.userId == userId).isMute == YorNType.Y) {
                                logic.resetMute(logic.id, userId);
                              } else {
                                logic.setMute(logic.id, userId);
                              }
                            }),
                        const Divider(height: .5),
                        RadiusInkWellWidget(
                            borderRadius:
                                BorderRadius.only(bottomRight: Radius.circular(8.r), bottomLeft: Radius.circular(8.r)),
                            color: Colors.transparent,
                            child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 22.w),
                                height: 50.h,
                                width: double.infinity,
                                alignment: Alignment.center,
                                child: Row(children: [
                                  Text("移除TA", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
                                  const Spacer(),
                                  const Icon(IconFont.remove_member, color: ColorUtil.color_333333)
                                ])),
                            onPressed: () {
                              Get.back();
                              logic.removeMemberFromGroup(logic.id, userId);
                            })
                      ]
                    : []
              ]))
        ]));
  }
}
