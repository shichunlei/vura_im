import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'color_util.dart';

Future<T?> show<T extends Object>(
    {Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
    required WidgetBuilder builder,
    RouteTransitionsBuilder? transitionBuilder,
    bool barrierDismissible = true,
    Color? barrierColor}) async {
  return showGeneralDialog<T>(
      context: Get.context!,
      transitionDuration: duration,
      barrierColor: barrierColor ?? Colors.black54,
      barrierDismissible: barrierDismissible,
      barrierLabel: '',
      pageBuilder: (context, _, __) {
        final child = builder(context);
        return Material(
            type: MaterialType.transparency,
            child: AnnotatedRegion<SystemUiOverlayStyle>(value: SystemUiOverlayStyle.light, child: child));
      },
      transitionBuilder: (BuildContext context, animation, secondaryAnimation, child) {
        final curveAnimation = CurvedAnimation(parent: animation, curve: curve);
        final secondCurveAnimation = CurvedAnimation(parent: secondaryAnimation, curve: curve);
        if (transitionBuilder == null) {
          return defaultTransitions(context, curveAnimation, secondCurveAnimation, child);
        } else {
          return transitionBuilder(context, curveAnimation, secondCurveAnimation, child);
        }
      });
}

/// 默认动画
RouteTransitionsBuilder get defaultTransitions => (BuildContext context, animation, secondaryAnimation, child) {
      final opciatyTween = Tween<double>(begin: 0.5, end: 1);
      final offsetTween = Tween<Offset>(begin: const Offset(0, 0.6), end: const Offset(0, 0));
      return FadeTransition(
          opacity: opciatyTween.animate(animation),
          child: SlideTransition(position: offsetTween.animate(animation), child: child));
    };

/// 无动画
RouteTransitionsBuilder get noAnimation => (BuildContext context, animation, secondaryAnimation, child) => child;

/// 弹性动画
RouteTransitionsBuilder get elasticTransitions =>
    (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
      return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: SlideTransition(
              position: Tween<Offset>(begin: const Offset(0.0, 0.3), end: Offset.zero).animate(CurvedAnimation(
                  parent: animation, curve: const ElasticOutCurve(0.85), reverseCurve: Curves.easeOutBack)),
              child: child));
    };

/// 选择图片
Future showImagePickerDialog(BuildContext context) async {
  return await showCupertinoModalPopup(
      context: context,
      builder: (_) {
        return CupertinoActionSheet(
            actions: [
              CupertinoActionSheetAction(
                  child: const Text("从相册选择", style: TextStyle(color: Colors.blue)),
                  onPressed: () async {
                    Get.back(result: ImageSource.gallery);
                  }),
              CupertinoActionSheetAction(
                  child: const Text("拍照", style: TextStyle(color: Colors.blue)),
                  onPressed: () async {
                    Get.back(result: ImageSource.camera);
                  })
            ],
            cancelButton: CupertinoActionSheetAction(
                onPressed: Get.back, child: Text("Cancel".tr, style: const TextStyle(color: ColorUtil.color_666666))));
      });
}
