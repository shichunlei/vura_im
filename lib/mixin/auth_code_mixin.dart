import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:im/base/base_logic.dart';
import 'package:im/entities/base64.dart';
import 'package:im/repository/common_repository.dart';

mixin AuthCodeMixin on BaseLogic {
  TextEditingController codeController = TextEditingController();

  Rx<Base64Entity?> base64Img = Rx<Base64Entity?>(null);

  Future getAuthCode() async {
    base64Img.value = await CommonRepository.getAuthCode();
  }

  TextEditingController securityIssuesController = TextEditingController();

  /// 密保问题
}
