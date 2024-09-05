import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vura/entities/emoji.dart';
import 'package:vura/entities/file_entity.dart';
import 'package:vura/entities/message_entity.dart';
import 'package:vura/entities/package_entity.dart';
import 'package:vura/entities/user_entity.dart';
import 'package:vura/global/enum.dart';
import 'package:vura/modules/im/widgets/item_send_emoji.dart';
import 'package:vura/utils/color_util.dart';
import 'package:vura/utils/date_util.dart';

import 'item_send_card.dart';
import 'item_send_image.dart';
import 'item_send_red_package.dart';
import 'item_send_text.dart';
import 'item_send_voice.dart';

class ItemSendMessage extends StatelessWidget {
  final MessageEntity message;
  final bool showTime;
  final String? tag;

  const ItemSendMessage({super.key, required this.message, this.showTime = false, this.tag});

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
      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        GestureDetector(
            onLongPress: () {
              /// TODO 消息长按操作
            },
            child: buildMessageView(message.type))
      ])
    ]);
  }

  Widget buildMessageView(int type) {
    if (type == MessageType.TEXT.code) return ItemSendText(message: message);
    if (type == MessageType.IMAGE.code && message.content != null) {
      return ItemSendImage(message: message, file: ImageEntity.fromJson(json.decode(message.content!)));
    }
    if (type == MessageType.ID_CARD.code && message.content != null) {
      return ItemSendCard(message: message, user: UserEntity.fromJson(json.decode(message.content!)));
    }
    if (type == MessageType.EMOJI.code && message.content != null) {
      return ItemSendEmoji(message: message, emoji: EmojiEntity.fromJson(json.decode(message.content!)));
    }
    if (type == MessageType.AUDIO.code && message.content != null) {
      return ItemSendVoice(message: message, tag: tag, file: AudioEntity.fromJson(json.decode(message.content!)));
    }
    if ((type == MessageType.RED_PACKAGE.code || type == MessageType.GROUP_RED_PACKAGE.code) &&
        message.content != null) {
      return ItemSendRedPackage(
          message: message, tag: tag, redPackage: RedPackageEntity.fromJson(json.decode(message.content!)));
    }
    return Text("暂未适配的消息类型${message.content}");
  }
}
