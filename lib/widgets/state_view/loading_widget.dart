import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingWidget extends StatelessWidget {
  final Color? bgColor;
  final double? height;

  const LoadingWidget({super.key, this.bgColor, this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: height ?? MediaQuery.of(context).size.height,
        child: Container(
            color: bgColor ?? Theme.of(context).scaffoldBackgroundColor,
            alignment: Alignment.center,
            child: SizedBox(height: 200, width: 200, child: SpinKitCircle(color: Theme.of(context).primaryColor))));
  }
}
