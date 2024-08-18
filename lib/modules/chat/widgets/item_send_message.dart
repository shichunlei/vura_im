import 'package:flutter/material.dart';
import 'package:im/entities/message_entity.dart';
import 'package:im/global/enum.dart';

import 'item_send_text.dart';

class ItemSendMessage extends StatelessWidget {
  final MessageEntity message;

  const ItemSendMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return buildMessageView(message.type);
  }

  Widget buildMessageView(int type) {
    if (type == MessageType.TEXT.code) {
      return ItemSendText(message: message);
    }
    return Container(child: Text("${message.content}"));
  }
}
