import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:im/widgets/widgets.dart';

import 'logic.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  RegisterLogic get logic => Get.find<RegisterLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("注册"), centerTitle: true),
        body: BaseWidget(
            logic: logic,
            builder: (logic) {
              return Column(children: [
                TextField(controller: logic.accountController),
                SizedBox(height: 20.h),
                TextField(controller: logic.passwordController),
                SizedBox(height: 20.h),
                TextField(controller: logic.nicknameController),
                SizedBox(height: 20.h),
                RadiusInkWellWidget(
                    padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 22.w),
                    onPressed: logic.register,
                    child: Container(alignment: Alignment.center, child: Text("注册")))
              ]);
            }));
  }
}
