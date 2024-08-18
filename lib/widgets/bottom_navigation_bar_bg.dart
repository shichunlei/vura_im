import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomNavigationBarBg extends StatelessWidget {
  final Widget? child;
  final Color? bgColor;

  const BottomNavigationBarBg({super.key, this.child, this.bgColor});

  @override
  Widget build(BuildContext context) {
    return Material(
        color: bgColor ?? Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        elevation: 20,
        borderRadius: BorderRadius.only(topRight: Radius.circular(16.w), topLeft: Radius.circular(16.w)),
        child: SafeArea(
            top: false,
            child:
                Container(padding: EdgeInsets.only(top: 10.w, right: 15.w, left: 15.w, bottom: 10.w), child: child)));
  }
}
