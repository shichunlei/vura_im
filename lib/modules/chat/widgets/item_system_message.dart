import 'package:flutter/material.dart';
import 'package:im/entities/message_entity.dart';

class ItemSystemMessage extends StatelessWidget {
  final MessageEntity message;

  const ItemSystemMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(alignment: Alignment.center, child: Text("${message.content}"));
  }
}
