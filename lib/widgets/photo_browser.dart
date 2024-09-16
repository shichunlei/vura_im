import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vura/utils/device_utils.dart';

class PhotoBrowserPage extends StatefulWidget {
  final List<String?>? urlStrArr;
  final int initialIndex;
  final List<String> tagArr;

  const PhotoBrowserPage(this.urlStrArr, {super.key, this.initialIndex = 0, this.tagArr = const []});

  @override
  createState() => _PhotoBrowserPageState();
}

class _PhotoBrowserPageState extends State<PhotoBrowserPage> {
  int count = 0;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();

    count = widget.initialIndex + 1;
    currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: Get.back,
        child: ExtendedImageSlidePage(
            slideAxis: SlideAxis.vertical,
            slideType: SlideType.onlyImage,
            child: Stack(children: [
              ExtendedImageGesturePageView.builder(
                  controller: ExtendedPageController(initialPage: widget.initialIndex, pageSpacing: 50),
                  itemBuilder: (context, index) {
                    var urlStr = widget.urlStrArr![index];
                    return ExtendedImage.network("$urlStr",
                        mode: ExtendedImageMode.gesture,
                        cache: true,
                        fit: BoxFit.fitWidth,
                        enableSlideOutPage: true, heroBuilderForSlidingPage: (child) {
                      return Hero(
                          tag: widget.tagArr.isNotEmpty ? widget.tagArr[currentIndex] : urlStr!,
                          child: child,
                          flightShuttleBuilder: (BuildContext flightContext,
                              Animation<double> animation,
                              HeroFlightDirection flightDirection,
                              BuildContext fromHeroContext,
                              BuildContext toHeroContext) {
                            final Hero hero = (flightDirection == HeroFlightDirection.pop
                                ? fromHeroContext.widget
                                : toHeroContext.widget) as Hero;
                            return hero;
                          });
                    }, loadStateChanged: (ExtendedImageState state) {
                      // if (state.extendedImageLoadState == LoadState.loading) {
                      //   return Image.asset("");
                      // }
                      return null;
                    });
                  },
                  itemCount: widget.urlStrArr!.length,
                  onPageChanged: (int index) {
                    if (mounted) {
                      setState(() {
                        count = index + 1;
                        currentIndex = index;
                      });
                    }
                  }),
              Positioned(
                  left: 0,
                  right: 0,
                  bottom: DeviceUtils.setBottomMargin(30.h),
                  child: Visibility(
                      visible: widget.urlStrArr!.length > 1,
                      child: Container(
                          alignment: Alignment.center,
                          child: Container(
                              width: 80.w,
                              height: 30.w,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(100)),
                              child: Center(
                                  child: Text('$count/${widget.urlStrArr!.length}',
                                      style: const TextStyle(color: Colors.white))))))),
              Positioned(top: DeviceUtils.topSafeHeight, right: 10.w, child: const CloseButton())
            ])));
  }
}
