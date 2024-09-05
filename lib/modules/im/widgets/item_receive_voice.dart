import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vura/entities/file_entity.dart';
import 'package:vura/entities/message_entity.dart';
import 'package:vura/global/icon_font.dart';
import 'package:vura/modules/im/chat/logic.dart';

class ItemReceiveVoice extends StatelessWidget {
  final MessageEntity message;
  final AudioEntity file;
  final String? tag;

  const ItemReceiveVoice({super.key, required this.message, required this.file, this.tag});

  ChatLogic get logic => Get.find<ChatLogic>(tag: tag);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.end, children: [
      GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            logic.play(file.fileUrl, message.id);
          },
          child: Container(
              margin: EdgeInsets.only(top: 5.h),
              padding: EdgeInsets.symmetric(horizontal: 22.w),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15.r),
                      topLeft: Radius.circular(5.r),
                      bottomRight: Radius.circular(15.r),
                      bottomLeft: Radius.circular(15.r)),
                  color: Colors.white),
              width: 140.w,
              height: 40.h,
              child: Row(children: [
                Icon(IconFont.receive_voice, color: const Color(0xff2ECC72), size: 22.sp),
                const Spacer(),
                Text('${file.duration / 1000}s',
                    style: TextStyle(color: const Color(0xff2ECC72), fontSize: 15.sp, fontWeight: FontWeight.w600))
              ]))),
      Obx(() {
        return Visibility(
            visible: logic.messagePlayingId.value == message.id && logic.curState.value == PlayerState.playing,
            child: Container(
                margin: EdgeInsets.only(left: 8.w, bottom: 6.h),
                height: 5.r,
                width: 5.r,
                decoration: BoxDecoration(color: const Color(0xff2ECC72), borderRadius: BorderRadius.circular(10))));
      })
    ]);
  }
}
