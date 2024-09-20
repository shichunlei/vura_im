import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vura/entities/message_entity.dart';
import 'package:vura/modules/root/logic.dart';

class ItemSendText extends StatelessWidget {
  final MessageEntity message;

  const ItemSendText({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onDoubleTap: () {},
        behavior: HitTestBehavior.translucent,
        child: Container(
            margin: EdgeInsets.only(top: 5.h),
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(5.r),
                    topLeft: Radius.circular(15.r),
                    bottomRight: Radius.circular(15.r),
                    bottomLeft: Radius.circular(15.r)),
                color: const Color(0xff2ECC72)),
            constraints: BoxConstraints(maxWidth: 266.w, minWidth: 0, minHeight: 44.r),
            child: Obx(() {
              return Text('${message.content}'.replaceAll(r'\n', "\n"),
                  style: TextStyle(
                      fontSize: Get.find<RootLogic>().textSizeType.value.fontSize.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w600));
            })));
  }
}
