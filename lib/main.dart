import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:im/route/app_pages.dart';
import 'package:im/utils/device_utils.dart';
import 'package:im/utils/log_utils.dart';

import 'application.dart';
import 'global/messages.dart';
import 'modules/root/binding.dart';

void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Application.getInstance().initApp();
    return launchApp();
  }, (Object error, StackTrace stack) {
    Log.d("");
  });
}

Future launchApp() async {
  /// 强制竖屏
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((value) async {
    runApp(const MyApp());

    if (DeviceUtils.isAndroid) {
      // 以下两行 设置android状态栏为透明的沉浸。
      SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(statusBarColor: Colors.transparent);
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final builder = BotToastInit();

    return GestureDetector(
        onTap: () {
          DeviceUtils.hideKeyboard(context);
        },
        child: ScreenUtilInit(
            designSize: const Size(414, 896),
            minTextAdapt: true,
            builder: (_, child) {
              return GetMaterialApp(
                  builder: (context, widget) {
                    return MediaQuery(
                        // 设置文字大小不随系统设置改变
                        data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
                        child: builder(context, widget));
                  },
                  navigatorObservers: [BotToastNavigatorObserver(), GetObserver()],
                  title: 'vura',
                  localizationsDelegates: const [
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate
                  ],
                  locale: const Locale("zh", "CN"),
                  translations: AppTranslations(),
                  fallbackLocale: const Locale('zh', 'CN'),
                  debugShowCheckedModeBanner: false,
                  themeMode: ThemeMode.light,
                  theme: ThemeData(
                      primaryColor: const Color(0xff83C240),
                      brightness: Brightness.light,
                      scaffoldBackgroundColor: const Color(0xfffafafa),
                      dividerColor: const Color(0xfff5f5f5),
                      dividerTheme: const DividerThemeData(color: Color(0xfff5f5f5)),
                      appBarTheme: AppBarTheme(
                          systemOverlayStyle: SystemUiOverlayStyle.dark,
                          elevation: 0,
                          backgroundColor: Colors.white,
                          titleTextStyle:
                              GoogleFonts.roboto(fontWeight: FontWeight.bold, fontSize: 20.sp, color: Colors.black))),
                  initialBinding: RootBinding(),
                  initialRoute: initialRoute,
                  getPages: AppPages.routes);
            }));
  }
}
