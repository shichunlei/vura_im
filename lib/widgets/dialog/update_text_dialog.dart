import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vura/utils/color_util.dart';

class UpdateTextDialog extends StatefulWidget {
  final String title;
  final String value;
  final int maxLines;
  final int minLines;

  const UpdateTextDialog({super.key, this.title = "修改", this.value = "", this.maxLines = 1, this.minLines = 1});

  @override
  createState() => _UpdateTextDialogState();
}

class _UpdateTextDialogState extends State<UpdateTextDialog> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller
      ..addListener(() {
        setState(() {});
      })
      ..text = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15.w)),
              margin: EdgeInsets.symmetric(horizontal: 40.w),
              padding: EdgeInsets.only(left: 15.w, right: 15.w, bottom: 10.w),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Container(
                    alignment: Alignment.center,
                    height: 50.w,
                    child: Text(widget.title, style: Theme.of(context).textTheme.titleMedium)),
                const Divider(height: 0),
                TextField(controller: controller, maxLines: widget.maxLines, minLines: widget.minLines),
                SizedBox(height: 10.w),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  TextButton(
                      onPressed: Get.back, child: const Text("取消", style: TextStyle(color: ColorUtil.color_999999))),
                  TextButton(
                      onPressed: () {
                        Get.back(result: controller.text);
                      },
                      child: const Text("确定"))
                ])
              ]))
        ]));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
