import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vura/entities/emoji.dart';
import 'package:vura/entities/message_entity.dart';

class ItemSendEmoji extends StatelessWidget {
  final MessageEntity message;
  final EmojiEntity emoji;

  const ItemSendEmoji({super.key, required this.message, required this.emoji});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {},
        child: Image.asset("assets/emoji_${emoji.type}/${emoji.path}",
            width: 100.r, height: 100.r, package: "emoji_picker"));
  }
}
