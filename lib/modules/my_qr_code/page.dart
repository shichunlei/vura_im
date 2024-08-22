import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:im/utils/color_util.dart';
import 'package:im/utils/string_util.dart';
import 'package:im/widgets/obx_widget.dart';
import 'package:im/widgets/round_image.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:screenshot/screenshot.dart';

import 'logic.dart';

class MyQrCodePage extends StatelessWidget {
  final String? tag;

  const MyQrCodePage({super.key, this.tag});

  MyQrCodeLogic get logic => Get.find<MyQrCodeLogic>(tag: tag);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("我的二维码"), centerTitle: true),
        body: BaseWidget(
            logic: logic,
            builder: (logic) {
              return Container(
                  margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 40.w),
                  child: Screenshot(
                      controller: logic.screenshotController,
                      child: Container(
                          width: double.infinity,
                          color: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 30.h),
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(children: [
                                  SizedBox(width: 20.w),
                                  RoundImage("${logic.bean.value?.headImageThumb}",
                                      width: 40.r,
                                      height: 40.r,
                                      radius: 8.r,
                                      errorWidget: StringUtil.isNotEmpty(logic.bean.value?.nickName)
                                          ? Container(
                                              width: 40.r,
                                              height: 40.r,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5.r),
                                                  border: Border.all(color: Colors.white, width: 1),
                                                  color: ColorUtil.strToColor(logic.bean.value!.nickName!)),
                                              alignment: Alignment.center,
                                              child: FittedBox(
                                                  fit: BoxFit.contain,
                                                  child: Padding(
                                                      padding: const EdgeInsets.all(2.0),
                                                      child: Text(logic.bean.value!.nickName![0],
                                                          style: TextStyle(fontSize: 20.sp, color: Colors.white)))))
                                          : Image.asset("assets/images/default_face.webp", width: 40.r, height: 40.r),
                                      placeholderImage: "assets/images/default_face.webp"),
                                  SizedBox(width: 8.w),
                                  Text("${logic.bean.value?.nickName}",
                                      style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.black))
                                ]),
                                Container(
                                    margin: EdgeInsets.only(top: 15.r, bottom: 30.r),
                                    width: 344.w,
                                    height: 344.w,
                                    alignment: Alignment.center,
                                    color: Colors.white,
                                    child: Obx(() {
                                      return PrettyQrView.data(
                                          errorCorrectLevel: QrErrorCorrectLevel.H,
                                          data: logic.qrCodeStr.value,
                                          decoration: PrettyQrDecoration(
                                              image: PrettyQrDecorationImage(
                                                  filterQuality: FilterQuality.high,
                                                  scale: .2,
                                                  image: StringUtil.isNotEmpty(logic.bean.value?.headImageThumb)
                                                      ? NetworkImage("${logic.bean.value?.headImageThumb}")
                                                      : const AssetImage("assets/images/default_face.webp"))));
                                    })),
                                Text('扫一扫上面的二维码图案，加我为好友',
                                    textAlign: TextAlign.center,
                                    style:
                                        Theme.of(context).textTheme.labelSmall!.copyWith(color: ColorUtil.color_999999))
                              ]))));
            }));
  }
}
