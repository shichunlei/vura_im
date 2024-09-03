import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vura/modules/root/logic.dart';
import 'package:vura/utils/color_util.dart';
import 'package:vura/utils/log_utils.dart';
import 'package:vura/widgets/radius_inkwell_widget.dart';

class VersionUpgradeDialog extends StatelessWidget {
  const VersionUpgradeDialog({super.key});

  RootLogic get logic => Get.find<RootLogic>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: !logic.version!.forceUpdate, // 强制升级时拦截android物理返回键
        onPopInvoked: (bool didPop) {
          Log.d("========================$didPop");
        },
        child: Material(
            color: Colors.transparent,
            child: Center(
                child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 40.w),
                    child: Stack(clipBehavior: Clip.none, children: [
                      Container(
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15.r)),
                          child: Column(mainAxisSize: MainAxisSize.min, children: [
                            SizedBox(height: 50.h),
                            Text("有新的版本更新啦", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp)),
                            SizedBox(height: 10.h),
                            Text('最新版本：${logic.version!.version}',
                                style: TextStyle(fontSize: 14.sp, color: ColorUtil.color_666666)),
                            SizedBox(height: 15.h),
                            ListView.separated(
                                shrinkWrap: true,
                                separatorBuilder: (context, index) => SizedBox(height: 3.h),
                                padding: EdgeInsets.symmetric(horizontal: 20.w),
                                itemCount: logic.version!.changesText.split("\n").length,
                                itemBuilder: (context, index) {
                                  return Container(
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.symmetric(vertical: 10.h),
                                      child: Text('${index + 1}.${logic.version!.changesText.split("\n")[index]}',
                                          style: TextStyle(color: ColorUtil.color_666666, fontSize: 14.sp)));
                                }),
                            SizedBox(height: 10.h),
                            Obx(() => !logic.isDownloading.value
                                ? Row(children: [
                                    SizedBox(width: 30.w),
                                    ...!logic.version!.forceUpdate
                                        ? [
                                            Expanded(
                                                child: RadiusInkWellWidget(
                                                    border:
                                                        Border.all(width: 1.w, color: Theme.of(context).primaryColor),
                                                    onPressed: Get.back,
                                                    radius: 40,
                                                    color: Colors.transparent,
                                                    child: Container(
                                                        height: 40.h,
                                                        alignment: Alignment.center,
                                                        child: Text('暂不更新',
                                                            style: TextStyle(color: Colors.grey, fontSize: 14.sp))))),
                                            SizedBox(width: 20.w)
                                          ]
                                        : [],
                                    Expanded(
                                        child: RadiusInkWellWidget(
                                            onPressed: () {
                                              if (Platform.isIOS) {
                                                logic.goStore();
                                              } else {
                                                // 弹出来apk下载进度的dialog，需要先检查权限
                                                logic.downloadAndroid();
                                              }
                                            },
                                            color: Theme.of(context).primaryColor,
                                            radius: 45.w,
                                            child: Container(
                                                height: 40.h,
                                                alignment: Alignment.center,
                                                child: Text("去升级",
                                                    style: TextStyle(color: Colors.white, fontSize: 14.sp))))),
                                    SizedBox(width: 30.w)
                                  ])
                                : logic.progress.value < 1
                                    ? Container(
                                        height: 40.h,
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                            height: 10.r,
                                            width: 251.w,
                                            child: Stack(children: [
                                              Container(
                                                  height: 10.r,
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5.r),
                                                      color: const Color(0xffEEEEEE))),
                                              Container(
                                                  height: 10.r,
                                                  width: 251.w * logic.progress.value,
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5.r),
                                                      gradient: const LinearGradient(colors: [
                                                        Color(0xffF21E1E),
                                                        Color(0xffF65429),
                                                        Color(0xffFFA15D)
                                                      ])))
                                            ])))
                                    : RadiusInkWellWidget(
                                        margin: EdgeInsets.symmetric(horizontal: 30.w),
                                        onPressed: logic.installApk,
                                        color: Theme.of(context).primaryColor,
                                        radius: 45.w,
                                        child: Container(
                                            height: 40.h,
                                            alignment: Alignment.center,
                                            child:
                                                Text("去安装", style: TextStyle(color: Colors.white, fontSize: 14.sp))))),
                            SizedBox(height: 15.h)
                          ])),
                      Positioned(
                          left: 0,
                          right: 0,
                          top: -40.r,
                          child: Image.asset("assets/images/version.png", width: 80.r, height: 80.r))
                    ])))));
  }
}
