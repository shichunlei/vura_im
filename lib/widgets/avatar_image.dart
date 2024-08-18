import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:im/utils/tool_util.dart';

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

  const AvatarImageView(this.path,
      {super.key,
      required this.radius,
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
                    errorWidget: (_, url, error) =>
                        Image.asset("assets/images/default_face.webp", width: 2 * radius, height: 2 * radius),
                    fit: fit,
                    fadeInDuration: Duration.zero,
                    fadeOutDuration: Duration.zero,
                    placeholderFadeInDuration: Duration.zero,
                    cacheManager: cacheManager))));
  }
}
