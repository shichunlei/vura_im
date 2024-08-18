import 'package:flutter/material.dart';

class CustomAppBarBottomView extends StatelessWidget implements PreferredSizeWidget {
  final Widget child;
  final double? height;

  const CustomAppBarBottomView({super.key, required this.child, this.height});

  @override
  Widget build(BuildContext context) {
    return child;
  }

  @override
  Size get preferredSize => Size.fromHeight(height ?? kToolbarHeight);
}
