import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:im/entities/message_entity.dart';
import 'package:im/widgets/avatar_image.dart';

import 'item_receive_text.dart';

class ItemReceiveMessage extends StatelessWidget {
  final MessageEntity message;

  const ItemReceiveMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [AvatarImageView("path", radius: 22.r, name: ""), buildMessageView(message.type)]);
  }

  Widget buildMessageView(int type) {
    switch (type) {
      case 0:
        return ItemReceiveText(message: message);
      default:
        return Container(child: Text("${message.content}"));
    }
  }
}
