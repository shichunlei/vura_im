import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:im/utils/log_utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'logic.dart';

class WebViewPage extends StatelessWidget {
  const WebViewPage({super.key});

  WebViewLogic get logic => Get.find<WebViewLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("${logic.title}")),
        body: Builder(builder: (BuildContext context) {
          return Column(children: [
            Obx(() => logic.loading.value
                ? SizedBox(
                    height: 1.r,
                    child: const LinearProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.grey), backgroundColor: Colors.blue))
                : const SizedBox.shrink()),
            Expanded(
                child: WebViewWidget(
                    controller: WebViewController()
                      ..setBackgroundColor(Colors.white)
                      ..setJavaScriptMode(JavaScriptMode.unrestricted)
                      ..loadRequest(Uri.parse("${logic.url}"))
                      ..setNavigationDelegate(NavigationDelegate(
                          onProgress: (int progress) {
                            // Update loading bar.
                            Log.d('onProgress: $progress');
                            if (progress == 100) logic.loading.value = false;
                          },
                          onPageStarted: (String url) {
                            Log.d('onPageStarted: $url');
                          },
                          onPageFinished: (String url) {
                            Log.d('onPageFinished: $url');
                          },
                          onWebResourceError: (WebResourceError error) {},
                          onNavigationRequest: (NavigationRequest request) {
                            return NavigationDecision.navigate;
                          }))))
          ]);
        }));
  }
}
