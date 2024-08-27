import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vura/entities/file_entity.dart';
import 'package:vura/entities/message_entity.dart';

class ItemReceiveImage extends StatelessWidget {
  final MessageEntity message;
  final FileEntity file;

  const ItemReceiveImage({super.key, required this.message, required this.file});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {},
        behavior: HitTestBehavior.translucent,
        child: Padding(
            padding: EdgeInsets.only(top: 5.h),
            child: Hero(
                tag: '${file.thumbUrl}',
                child: ExtendedImage.network("${file.thumbUrl}",
                    enableLoadState: false,
                    fit: BoxFit.contain,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15.r),
                        topLeft: Radius.circular(5.r),
                        bottomRight: Radius.circular(15.r),
                        bottomLeft: Radius.circular(15.r)),
                    cache: true, loadStateChanged: (ExtendedImageState state) {
                  double maxHeight = 170.h;
                  double maxWidth = 250.w;

                  double? boxHeight;
                  double? boxWidth;
                  if (state.extendedImageLoadState == LoadState.completed) {
                    int height = state.extendedImageInfo!.image.height;
                    int width = state.extendedImageInfo!.image.width;

                    if (height > maxHeight || width > maxWidth) {
                      if (height > width) {
                        boxHeight = maxHeight;
                        boxWidth = maxHeight * width / height;
                      } else {
                        boxWidth = maxWidth;
                        boxHeight = maxWidth * height / width;
                      }
                    } else {
                      boxHeight = height.toDouble();
                      boxWidth = width.toDouble();
                    }

                    return ExtendedRawImage(
                        height: boxHeight, width: boxWidth, image: state.extendedImageInfo!.image, fit: BoxFit.contain);
                  }
                  return null;
                }))));
  }
}
