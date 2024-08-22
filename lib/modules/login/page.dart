import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:im/route/route_path.dart';
import 'package:im/widgets/obx_widget.dart';
import 'package:im/widgets/radius_inkwell_widget.dart';

import 'logic.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  LoginLogic get logic => Get.find<LoginLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("登录"), centerTitle: true),
        body: BaseWidget(
            logic: logic,
            builder: (logic) {
              return Column(children: [
                TextField(controller: logic.accountController),
                SizedBox(height: 20.h),
                TextField(controller: logic.passwordController),
                SizedBox(height: 20.h),
                Row(children: [
                  RadiusInkWellWidget(
                      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 22.w),
                      onPressed: logic.login,
                      child: Container(alignment: Alignment.center, child: Text("登录"))),
                  RadiusInkWellWidget(
                      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 22.w),
                      onPressed: () {
                        Get.toNamed(RoutePath.REGISTER_PAGE);
                      },
                      child: Container(alignment: Alignment.center, child: Text("注册"))),
                ])
              ]);
            }));
  }
}
