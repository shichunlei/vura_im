import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vura/route/app_pages.dart';
import 'package:vura/utils/color_util.dart';
import 'package:vura/utils/device_utils.dart';
import 'package:vura/utils/enum_to_string.dart';
import 'package:vura/utils/log_utils.dart';
import 'package:vura/utils/sp_util.dart';

import 'application.dart';
import 'global/enum.dart';
import 'global/keys.dart';
import 'global/messages.dart';
import 'modules/root/binding.dart';

void main() async {
  ErrorWidget.builder = (FlutterErrorDetails details) => AppErrorWidget(details: details); // This line does the magic!
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Application.getInstance().initApp();
    return launchApp();
  }, (Object error, StackTrace stack) {
    Log.e("---------------------------------ERROR start-----------------------------------");
    Log.e(error.toString());
    Log.e("---------------------------------ERROR end-----------------------------------");
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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late LocalType localType;

  @override
  void initState() {
    localType = EnumToString.fromString(
        LocalType.values, SpUtil.getString(Keys.LANGUAGE, defValue: LocalType.zh_CN.name),
        defaultValue: LocalType.zh_CN)!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final builder = BotToastInit();

    return GestureDetector(
        onTap: () => DeviceUtils.hideKeyboard(context),
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
                  locale: localType.locale,
                  translations: AppTranslations(),
                  fallbackLocale: const Locale('zh', 'CN'),
                  debugShowCheckedModeBanner: false,
                  themeMode: ThemeMode.light,
                  theme: ThemeData(
                      primaryColor: ColorUtil.mainColor,
                      brightness: Brightness.light,
                      colorScheme: ColorScheme.fromSeed(
                          seedColor: const Color(0xff83C240),
                          brightness: Brightness.light,
                          surfaceTint: Colors.transparent),
                      scaffoldBackgroundColor: const Color(0xfffafafa),
                      dividerColor: ColorUtil.lineColor,
                      dividerTheme: const DividerThemeData(color: ColorUtil.lineColor),
                      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                          backgroundColor: Colors.white, selectedItemColor: Color(0xff83C240)),
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

class AppErrorWidget extends StatelessWidget {
  final FlutterErrorDetails details;

  const AppErrorWidget({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.white,
        child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.warning, size: 200, color: Colors.amber),
              const SizedBox(height: 48),
              const Text('So... something funny happened',
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Text(
                  'This error is crazy large it covers your whole screen. But no worries'
                  ' though, we\'re working to fix it.\n${details.toString()}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16))
            ])));
  }
}
