import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';

class ChatBackgroundPage extends StatelessWidget {
  const ChatBackgroundPage({super.key});

  ChatBackgroundLogic get logic => Get.find<ChatBackgroundLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("聊天背景"), actions: [TextButton(onPressed: () {}, child: const Text("默认"))]),
        body: Column(children: []));
  }
}
