import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vura/widgets/avatar_image.dart';

import 'red_packet_controller.dart';
import 'red_packet_painter.dart';

OverlayEntry? entry;

void showRedPacket(BuildContext context, Function? onOpen,
    {String? nickName, String? headImage, String? redPackageId, String? coverImage}) {
  entry = OverlayEntry(
      builder: (_) => RedPacket(
          onFinish: _removeRedPacket,
          onOpen: onOpen,
          nickName: nickName,
          headImage: headImage,
          redPackageId: redPackageId,
          coverImage: coverImage));
  Overlay.of(context).insert(entry!);
}

void _removeRedPacket() {
  entry?.remove();
  entry = null;
}

class RedPacket extends StatefulWidget {
  final Function? onFinish;
  final Function? onOpen;
  final String? nickName;
  final String? headImage;
  final String? redPackageId;
  final String? coverImage;

  const RedPacket(
      {super.key, this.onFinish, this.onOpen, this.nickName, this.headImage, this.redPackageId, this.coverImage});

  @override
  createState() => _RedPacketState();
}

class _RedPacketState extends State<RedPacket> with TickerProviderStateMixin {
  late RedPacketController controller = RedPacketController(tickerProvider: this);

  @override
  void initState() {
    super.initState();
    controller.onOpen = widget.onOpen;
    controller.onFinish = widget.onFinish;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        color: const Color(0x88000000),
        child: GestureDetector(
            child: ScaleTransition(
                scale: Tween<double>(begin: 0, end: 1.0)
                    .animate(CurvedAnimation(parent: controller.scaleController, curve: Curves.fastOutSlowIn)),
                child: buildRedPacket()),
            onPanDown: (d) => controller.handleClick(d.globalPosition)));
  }

  Widget buildRedPacket() {
    return GestureDetector(
        onTapUp: (TapUpDetails details) {
          controller.clickGold(details, widget.redPackageId);
        },
        child: CustomPaint(
            size: Size(1.sw, 1.sh), painter: RedPacketPainter(controller: controller), child: buildChild()));
  }

  Widget buildChild() {
    return AnimatedBuilder(
        animation: controller.translateController,
        builder: (context, child) => Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              SizedBox(height: 0.3.sh * (1 - controller.translateCtrl.value)),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                AvatarRoundImage("${widget.headImage}", radius: 3.r, height: 24.w, width: 24.w, name: widget.nickName),
                SizedBox(width: 5.w),
                Text("${widget.nickName}发出的红包",
                    style: TextStyle(fontSize: 16.sp, color: const Color(0xFFF8E7CB), fontWeight: FontWeight.w500))
              ]),
              SizedBox(height: 15.w),
              Text("恭喜发财", style: TextStyle(fontSize: 18.sp, color: const Color(0xFFF8E7CB))),
              Image.asset("${widget.coverImage}")
            ]));
  }
}
