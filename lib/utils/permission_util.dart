import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'log_utils.dart';

class PermissionUtil {
  PermissionUtil._();

  /// 申请联系人权限
  static Future<bool> checkContactsPermissionStatus(BuildContext context) async {
    /// 检查是否已有该权限
    bool status = await Permission.contacts.isGranted;

    /// 判断如果还没拥有读写权限就申请获取权限
    if (!status) {
      if (!context.mounted) return false;
      return await checkPermissionTip(context, Permission.contacts, "您是否允许“vura”访问您本机的通讯录功能？");
    } else {
      return status;
    }
  }

  static Future<bool> checkPermissionTip(BuildContext context, Permission permission, String content) async {
    Log.d("权限 ${permission.value} 是否被永久拒绝 ${await permission.isPermanentlyDenied}");

    if (await permission.isPermanentlyDenied) {
      openAppSettings();
      return false;
    } else {
      if (!context.mounted) return false;
      return await showCupertinoDialog(
          context: context,
          builder: (_) {
            return CupertinoAlertDialog(title: const Text("提示"), content: Text(content), actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text("拒绝", style: TextStyle(color: Colors.red))),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text("确认"))
            ]);
          }).then((value) async {
        if (value != null && value) {
          if (await requestPermission(permission)) {
            return true;
          } else {
            openAppSettings();
            return false;
          }
        } else {
          return false;
        }
      });
    }
  }

  /// 检查该权限的状态
  static Future<bool> checkPermissionStatus(Permission permission) async {
    /// 检查是否已有该权限
    bool status = await permission.isGranted;

    /// 判断如果还没拥有读写权限就申请获取权限
    if (!status) {
      return await requestPermission(permission);
    } else {
      return status;
    }
  }

  /// 注册权限
  static Future<bool> requestPermission(Permission permission) async {
    return await permission.request().isGranted;
  }
}
