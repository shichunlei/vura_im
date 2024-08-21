import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:im/utils/tool_util.dart';

enum ImageType { network, assets, file }

Widget defaultPlaceholderWidget = Container(color: const Color(0xfff5f5f5));

/// 圆角图片
class RoundImage extends StatelessWidget {
  /// 半径
  final double radius;

  final BorderRadiusGeometry? borderRadius;

  final double? height;

  final double? width;

  /// 边框
  final BoxBorder? border;

  final BoxFit fit;

  /// 文件路径
  final String? path;

  final VoidCallback? onTap;

  final ImageType source;

  final Widget? maskChild;

  /// 后缀
  final String? suffix;

  /// 占位图片
  final String? placeholderImage;

  final String? errorImage;

  /// 占位控件
  final Widget? placeholderWidget;

  /// 占位控件
  final Widget? errorWidget;

  final EdgeInsetsGeometry? margin;

  final double? minHeight;

  const RoundImage(this.path,
      {super.key,
      this.radius = .0,
      this.borderRadius,
      this.width,
      this.height,
      this.border,
      this.onTap,
      this.fit = BoxFit.cover,
      this.source = ImageType.network,
      this.maskChild,
      this.suffix,
      this.placeholderImage,
      this.margin,
      this.minHeight,
      this.placeholderWidget,
      this.errorImage,
      this.errorWidget});

  @override
  Widget build(BuildContext context) {
    late Widget imageView;
    switch (source) {
      case ImageType.network:
        imageView = CachedNetworkImage(
            imageBuilder: (context, imageProvider) {
              return Container(
                  decoration: BoxDecoration(
                      borderRadius: borderRadius ?? BorderRadius.circular(radius),
                      image: DecorationImage(image: imageProvider, fit: fit)));
            },
            width: width,
            height: height,
            fadeInDuration: const Duration(milliseconds: 100),
            fadeOutDuration: const Duration(milliseconds: 100),
            placeholderFadeInDuration: const Duration(milliseconds: 100),
            imageUrl: "$path",
            placeholder: (context, url) =>
                placeholderWidget ?? Image.asset(placeholderImage ?? "assets/images/loading.png", fit: BoxFit.cover),
            errorWidget: (context, url, error) =>
                errorWidget ?? Image.asset(errorImage ?? "assets/images/loading.png", fit: BoxFit.cover),
            fit: fit,
            cacheManager: cacheManager);
        break;
      case ImageType.assets:
        imageView = Image.asset("$path", fit: fit);
        break;
      case ImageType.file:
        imageView = Image.file(File("$path"), fit: fit);
        break;
      default:
        break;
    }

    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap?.call,
        child: Container(
            constraints: BoxConstraints(minHeight: minHeight ?? 0),
            margin: margin ?? EdgeInsets.zero,
            decoration: BoxDecoration(border: border, borderRadius: borderRadius ?? BorderRadius.circular(radius)),
            height: height,
            width: width,
            child: ClipRRect(
                borderRadius: borderRadius as BorderRadius? ?? BorderRadius.circular(radius),
                child: Stack(children: [imageView, maskChild ?? const SizedBox()]))));
  }
}
