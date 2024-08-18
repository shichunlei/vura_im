import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:im/global/icon_font.dart';
import 'package:im/utils/color_util.dart';
import 'package:im/utils/device_utils.dart';
import 'package:im/utils/string_util.dart';

import 'custom_icon_button.dart';

class AppBarBottomSearchView extends StatefulWidget implements PreferredSizeWidget {
  final String hintText;
  final ValueChanged<String> onSubmitted;
  final Color? searchBgColor;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final VoidCallback? onClear;

  const AppBarBottomSearchView(
      {super.key,
      this.hintText = '请输入关键词',
      required this.onSubmitted,
      this.searchBgColor,
      this.onChanged,
      this.controller,
      this.onClear});

  @override
  createState() => _AppBarBottomSearchViewState();

  @override
  Size get preferredSize => Size.fromHeight(50.h);
}

class _AppBarBottomSearchViewState extends State<AppBarBottomSearchView> {
  TextEditingController? controller;

  @override
  void initState() {
    super.initState();

    if (widget.controller == null) {
      controller = TextEditingController()
        ..addListener(() {
          if (mounted) setState(() {});
        });
    } else {
      controller = widget.controller;
      controller!.addListener(() {
        if (mounted) setState(() {});
      });
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 22.w, bottom: 5.h, right: 22.w),
        height: 45.h,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(9.r), color: const Color(0xfff5f5f5)),
        alignment: Alignment.center,
        child: Row(children: [
          CustomIconButton(radius: 22.r, icon: Icon(IconFont.search, color: ColorUtil.color_999999, size: 18.sp)),
          Expanded(
              child: TextField(
                  controller: controller,
                  maxLines: 1,
                  textInputAction: TextInputAction.search,
                  style: GoogleFonts.roboto(fontSize: 15.sp, color: ColorUtil.color_333333),
                  onSubmitted: (v) {
                    DeviceUtils.hideKeyboard(context);
                    widget.onSubmitted.call(v);
                  },
                  onChanged: widget.onChanged?.call,
                  decoration: InputDecoration(
                      isCollapsed: true,
                      border: InputBorder.none,
                      hintText: widget.hintText,
                      hintStyle: GoogleFonts.roboto(fontSize: 13.sp, color: ColorUtil.color_999999)))),
          ...StringUtil.isNotEmpty(controller?.text)
              ? [
                  CustomIconButton(
                      radius: 22.r,
                      icon: const Icon(Icons.clear, color: ColorUtil.color_999999),
                      onPressed: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        controller?.text = '';
                        widget.onChanged?.call("");
                        if (mounted) setState(() {});
                        widget.onClear?.call();
                      })
                ]
              : []
        ]));
  }
}
