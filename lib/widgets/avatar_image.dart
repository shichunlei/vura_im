import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vura/utils/color_util.dart';
import 'package:vura/utils/string_util.dart';
import 'package:vura/utils/tool_util.dart';

/// 头像图片
class AvatarImageView extends StatelessWidget {
  /// 半径
  final double radius;

  /// 文件路径
  final String path;

  final VoidCallback? onTap;

  /// 边框颜色
  final Color borderColor;

  /// 边框宽度
  final double borderWidth;

  final BoxFit fit;

  final String? name;

  const AvatarImageView(this.path,
      {super.key,
      required this.radius,
      required this.name,
      this.onTap,
      this.borderColor = Colors.transparent,
      this.borderWidth = 0.0,
      this.fit = BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap?.call,
        child: Container(
            width: 2 * radius,
            height: 2 * radius,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: Border.all(color: borderColor, width: borderWidth),
                borderRadius: BorderRadius.circular(radius)),
            child: ClipOval(
                child: CachedNetworkImage(
                    width: 2 * radius,
                    height: 2 * radius,
                    imageUrl: path,
                    placeholder: (_, url) =>
                        Image.asset("assets/images/default_face.webp", width: 2 * radius, height: 2 * radius),
                    errorWidget: (_, url, error) => StringUtil.isNotEmpty(name)
                        ? Container(
                            width: radius * 2,
                            height: radius * 2,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(radius),
                                border: Border.all(color: Colors.white, width: 1),
                                color: ColorUtil.strToColor(name!)),
                            alignment: Alignment.center,
                            child: FittedBox(
                                fit: BoxFit.contain,
                                child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text(name![0],
                                        style: TextStyle(
                                            fontSize: 28.sp, fontWeight: FontWeight.bold, color: Colors.white)))))
                        : Image.asset("assets/images/default_face.webp", width: 2 * radius, height: 2 * radius),
                    fit: fit,
                    fadeInDuration: Duration.zero,
                    fadeOutDuration: Duration.zero,
                    placeholderFadeInDuration: Duration.zero,
                    cacheManager: cacheManager))));
  }
}

class AvatarRoundImage extends StatelessWidget {
  /// 半径
  final double radius;

  /// 文件路径
  final String path;

  final VoidCallback? onTap;

  /// 边框
  final BoxBorder? border;

  final double? height;

  final double? width;

  final String? name;

  final Decoration? foregroundDecoration;

  const AvatarRoundImage(this.path,
      {super.key,
      required this.radius,
      this.onTap,
      this.border,
      this.height,
      this.width,
      this.name,
      this.foregroundDecoration});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap?.call,
        child: Container(
            foregroundDecoration: foregroundDecoration,
            decoration: BoxDecoration(border: border, borderRadius: BorderRadius.circular(radius)),
            height: height,
            width: width,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(radius),
                child: CachedNetworkImage(
                    imageBuilder: (context, imageProvider) {
                      return Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(radius),
                              image: DecorationImage(image: imageProvider, fit: BoxFit.cover)));
                    },
                    width: width,
                    height: height,
                    imageUrl: path,
                    placeholder: (context, url) => Image.asset("assets/images/default_face.webp", fit: BoxFit.cover),
                    errorWidget: (context, url, error) => StringUtil.isNotEmpty(name)
                        ? Container(
                            height: height,
                            width: width,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(radius),
                                border: border,
                                color: ColorUtil.strToColor(name!)),
                            alignment: Alignment.center,
                            child: FittedBox(
                                fit: BoxFit.contain,
                                child: Padding(
                                    padding: const EdgeInsets.all(2),
                                    child: Text(name![0], style: TextStyle(fontSize: 40.sp, color: Colors.white)))))
                        : Image.asset("assets/images/default_face.webp", height: height, width: width),
                    fit: BoxFit.cover,
                    cacheManager: cacheManager))));
  }
}
