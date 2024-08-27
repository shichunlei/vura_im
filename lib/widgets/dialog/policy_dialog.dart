import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vura/global/keys.dart';
import 'package:vura/route/route_path.dart';
import 'package:vura/widgets/radius_inkwell_widget.dart';

/// 登录前隐私政策提示弹窗
class PolicyDialog extends StatelessWidget {
  final VoidCallback? onConfirm;

  const PolicyDialog({super.key, this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        child: Center(
            child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.w), color: Theme.of(context).cardColor),
                width: 285.w,
                padding: EdgeInsets.only(top: 22.w),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Text("用户协议以及隐私政策", style: Theme.of(context).textTheme.titleMedium),
                  Container(
                      margin: EdgeInsets.only(bottom: 23.w, top: 18.w, left: 16.w, right: 16.w),
                      alignment: Alignment.centerLeft,
                      child: RichText(
                          text: TextSpan(
                              text: '请您仔细阅读并同意球掌门',
                              children: [
                                TextSpan(
                                    text: "《隐私政策》",
                                    style: const TextStyle(color: Colors.blue),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Get.toNamed(RoutePath.WEBVIEW_PAGE,
                                            arguments: {"url": "/privacy.html", Keys.TITLE: "隐私政策"});
                                      }),
                                TextSpan(
                                    text: "《用户协议》",
                                    style: const TextStyle(color: Colors.blue),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Get.toNamed(RoutePath.WEBVIEW_PAGE,
                                            arguments: {"url": "/register.html", Keys.TITLE: "用户协议"});
                                      })
                              ],
                              style: Theme.of(context).textTheme.bodyMedium),
                          textAlign: TextAlign.justify)),
                  Container(width: double.infinity, height: 1, color: Theme.of(context).dividerColor),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Expanded(
                        child: RadiusInkWellWidget(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8.w)),
                            onPressed: Get.back,
                            child: Container(
                                alignment: Alignment.center,
                                height: 42.w,
                                child: Text("不同意",
                                    style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 15.sp))))),
                    Container(width: 1, height: 42.w, color: Theme.of(context).dividerColor),
                    Expanded(
                        child: RadiusInkWellWidget(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.only(bottomRight: Radius.circular(8.w)),
                            border: Border.all(color: Colors.transparent, width: .5),
                            onPressed: () {
                              Get.back();
                              onConfirm?.call();
                            },
                            child: Container(
                                alignment: Alignment.center,
                                height: 42.w,
                                child: Text("同意并继续",
                                    style: TextStyle(
                                        color: Colors.redAccent, fontSize: 15.sp, fontWeight: FontWeight.w500)))))
                  ])
                ]))));
  }
}
