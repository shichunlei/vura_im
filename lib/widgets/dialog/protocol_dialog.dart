import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:im/global/keys.dart';
import 'package:im/route/route_path.dart';
import 'package:im/widgets/radius_inkwell_widget.dart';

class ProtocolDialog extends StatelessWidget {
  const ProtocolDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        child: Center(
            child: Container(
                width: 313.w,
                padding: EdgeInsets.all(20.w),
                decoration: ShapeDecoration(
                    color: Theme.of(context).dialogBackgroundColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r))),
                child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('欢迎使用球掌门APP', style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 26.sp)),
                  SizedBox(height: 10.w),
                  SizedBox(
                      height: 180.r,
                      child: SingleChildScrollView(
                          child: RichText(
                              text: TextSpan(
                                  text: '请您在使用球掌门APP前仔细阅读并同意',
                                  children: [
                                    TextSpan(
                                        text: "《用户协议》",
                                        style: const TextStyle(color: Colors.blue),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Get.toNamed(RoutePath.WEBVIEW_PAGE,
                                                arguments: {"url": "/register.html", Keys.TITLE: "用户协议"});
                                          }),
                                    const TextSpan(text: "以及"),
                                    TextSpan(
                                        text: "《隐私政策》",
                                        style: const TextStyle(color: Colors.blue),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Get.toNamed(RoutePath.WEBVIEW_PAGE,
                                                arguments: {"url": "/privacy.html", Keys.TITLE: "隐私政策"});
                                          }),
                                    const TextSpan(
                                        text:
                                            "。你在使用球掌门App（以下简称“球掌门”）服务之前，请你务必审慎阅读、充分理解本协议各条款内容，特别是以粗体标注的部分，特别是免除或者限制责任的条款、法律适用和争议解决条款等以粗体划线重点标识的条款。如果你对本协议的内容有任何疑问，请向球掌门客服咨询。如你不同意本服务协议或随时对其的修改，你应立即停止注册使用；你一旦使用球掌门提供的服务，即视为你已了解并完全同意本服务协议各项内容，包括球掌门对服务协议所做的修改，并成为我们的用户。")
                                  ],
                                  style: Theme.of(context).textTheme.titleSmall),
                              textAlign: TextAlign.justify))),
                  SizedBox(height: 10.w),
                  RichText(
                      text: TextSpan(
                          text: '请您仔细阅读并同意',
                          children: [
                            TextSpan(
                                text: "《用户协议》",
                                style: const TextStyle(color: Colors.blue),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Get.toNamed(RoutePath.WEBVIEW_PAGE,
                                        arguments: {"url": "/register.html", Keys.TITLE: "用户协议"});
                                  }),
                            const TextSpan(text: "以及"),
                            TextSpan(
                                text: "《隐私政策》",
                                style: const TextStyle(color: Colors.blue),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Get.toNamed(RoutePath.WEBVIEW_PAGE,
                                        arguments: {"url": "/privacy.html", Keys.TITLE: "隐私政策"});
                                  })
                          ],
                          style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 14.sp)),
                      textAlign: TextAlign.justify),
                  Row(children: [
                    Expanded(
                        child: RadiusInkWellWidget(
                            border: Border.all(color: Colors.red, width: 1.r),
                            onPressed: () => Get.back(result: false),
                            radius: 25.w,
                            color: Colors.transparent,
                            margin: EdgeInsets.only(top: 10.w, right: 5.w),
                            child: Container(
                                width: double.infinity,
                                height: 38.r,
                                alignment: Alignment.center,
                                child: Text('拒绝', style: TextStyle(color: Colors.red, fontSize: 16.sp))))),
                    Expanded(
                        child: RadiusInkWellWidget(
                            onPressed: () {
                              Get.back(result: true);
                            },
                            radius: 25.w,
                            margin: EdgeInsets.only(top: 10.w, left: 5.w),
                            child: Container(
                                width: double.infinity,
                                height: 40.r,
                                alignment: Alignment.center,
                                child: Text('同意', style: TextStyle(color: Colors.white, fontSize: 16.sp)))))
                  ])
                ]))));
  }
}
