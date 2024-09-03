import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vura/utils/log_utils.dart';
import 'package:xbr_plugin_record/flutter_plugin_record.dart';
import 'package:xbr_plugin_record/widgets/custom_overlay.dart';

class VoiceRecordWidget extends StatefulWidget {
  final Function startRecord;
  final Function(String? path, double? audioTimeLength, bool isCancel) stopRecord;
  final double? height;
  final EdgeInsets? margin;
  final Decoration? decoration;
  final TextStyle? textStyle;

  /// startRecord 开始录制回调  stopRecord回调
  const VoiceRecordWidget(
      {super.key,
      required this.startRecord,
      required this.stopRecord,
      this.height,
      this.decoration,
      this.margin,
      this.textStyle});

  @override
  createState() => _VoiceRecordWidgetState();
}

class _VoiceRecordWidgetState extends State<VoiceRecordWidget> {
  double starty = 0.0;
  double offset = 0.0;
  bool isUp = false;
  String textShow = "按住说话";
  String toastShow = "手指上滑,取消发送";
  String voiceIco = "assets/images/voice_volume_1.png";

  ///默认隐藏状态
  bool voiceState = true;
  FlutterPluginRecord? recordPlugin;

  OverlayEntry? overlayEntry;

  @override
  void initState() {
    super.initState();
    recordPlugin = FlutterPluginRecord()..init();

    /// 初始化方法的监听
    recordPlugin!.responseFromInit.listen((data) {
      if (data) {
        Log.d("初始化成功");
      } else {
        Log.d("初始化失败");
      }
    });

    /// 开始录制或结束录制的监听
    recordPlugin!.response.listen((data) {
      if (data.msg == "onStop") {
        ///结束录制时会返回录制文件的地址方便上传服务器
        Log.d("onStop  ${data.path!}");
        widget.stopRecord.call(data.path, data.audioTimeLength, isUp);
      } else if (data.msg == "onStart") {
        Log.d("onStart --");
        widget.startRecord.call();
      }
    });

    ///录制过程监听录制的声音的大小 方便做语音动画显示图片的样式
    recordPlugin!.responseFromAmplitude.listen((data) {
      var voiceData = double.parse(data.msg ?? '');
      setState(() {
        if (voiceData > 0 && voiceData < 0.1) {
          voiceIco = "assets/images/voice_volume_2.png";
        } else if (voiceData > 0.2 && voiceData < 0.3) {
          voiceIco = "assets/images/voice_volume_3.png";
        } else if (voiceData > 0.3 && voiceData < 0.4) {
          voiceIco = "assets/images/voice_volume_4.png";
        } else if (voiceData > 0.4 && voiceData < 0.5) {
          voiceIco = "assets/images/voice_volume_5.png";
        } else if (voiceData > 0.5 && voiceData < 0.6) {
          voiceIco = "assets/images/voice_volume_6.png";
        } else if (voiceData > 0.6 && voiceData < 0.7) {
          voiceIco = "assets/images/voice_volume_7.png";
        } else if (voiceData > 0.7 && voiceData < 1) {
          voiceIco = "assets/images/voice_volume_7.png";
        } else {
          voiceIco = "assets/images/voice_volume_1.png";
        }
        if (overlayEntry != null) overlayEntry!.markNeedsBuild();
      });

      Log.d("振幅大小   $voiceData  $voiceIco");
    });
  }

  /// 显示录音悬浮布局
  void buildOverLayView(BuildContext context) {
    if (overlayEntry == null) {
      overlayEntry = OverlayEntry(builder: (content) {
        return CustomOverlay(
          icon: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(margin: const EdgeInsets.only(top: 10), child: Image.asset(voiceIco, width: 100, height: 100)),
            Text(toastShow, style: TextStyle(fontStyle: FontStyle.normal, color: Colors.white, fontSize: 14.sp))
          ]),
        );
      });
      Overlay.of(context).insert(overlayEntry!);
    }
  }

  void showVoiceView() async {
    setState(() {
      textShow = "松开结束";
      voiceState = false;
    });

    /// 显示录音悬浮布局
    buildOverLayView(context);

    /// 开始语音录制的方法
    await recordPlugin?.start();
  }

  void hideVoiceView() async {
    textShow = "按住说话";
    voiceState = true;

    if (overlayEntry != null) {
      overlayEntry?.remove();
      overlayEntry = null;
    }

    /// 停止语音录制的方法
    await recordPlugin?.stop();

    if (isUp) {
      Log.d("取消发送");
    } else {
      Log.d("进行发送");
    }

    setState(() {});
  }

  void moveVoiceView() {
    setState(() {
      isUp = starty - offset > 100 ? true : false;
      if (isUp) {
        textShow = "松开手指,取消发送";
        toastShow = textShow;
      } else {
        textShow = "松开结束";
        toastShow = "手指上滑,取消发送";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onLongPressStart: (details) async {
          starty = details.globalPosition.dy;
          showVoiceView();
        },
        onLongPressEnd: (details) => hideVoiceView(),
        onLongPressMoveUpdate: (details) {
          offset = details.globalPosition.dy;
          moveVoiceView();
        },
        child: Container(
            height: widget.height ?? 60,
            decoration: widget.decoration ??
                BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0),
                    border: Border.all(width: 1.0, color: Colors.grey.shade200)),
            margin: widget.margin ?? const EdgeInsets.fromLTRB(50, 0, 50, 20),
            alignment: Alignment.center,
            child: Text(textShow, style: widget.textStyle)));
  }

  @override
  void dispose() {
    recordPlugin?.stop();
    recordPlugin?.dispose();
    if (overlayEntry != null) {
      overlayEntry?.remove();
      overlayEntry = null;
    }
    super.dispose();
  }
}
