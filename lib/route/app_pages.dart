import 'package:get/get.dart';
import 'package:im/global/keys.dart';
import 'package:im/modules/account/binding.dart';
import 'package:im/modules/account/page.dart';
import 'package:im/modules/chat/binding.dart';
import 'package:im/modules/chat/page.dart';
import 'package:im/modules/home/binding.dart';
import 'package:im/modules/home/page.dart';
import 'package:im/modules/language/binding.dart';
import 'package:im/modules/language/page.dart';
import 'package:im/modules/line/binding.dart';
import 'package:im/modules/line/page.dart';
import 'package:im/modules/login/binding.dart';
import 'package:im/modules/login/page.dart';
import 'package:im/modules/personal/binding.dart';
import 'package:im/modules/personal/page.dart';
import 'package:im/modules/privacy/binding.dart';
import 'package:im/modules/privacy/page.dart';
import 'package:im/modules/register/binding.dart';
import 'package:im/modules/register/page.dart';
import 'package:im/modules/select_contacts/binding.dart';
import 'package:im/modules/select_contacts/page.dart';
import 'package:im/modules/session_detail/binding.dart';
import 'package:im/modules/session_detail/page.dart';
import 'package:im/modules/setting/binding.dart';
import 'package:im/modules/setting/page.dart';
import 'package:im/modules/windows/binding.dart';
import 'package:im/modules/windows/page.dart';
import 'package:im/route/route_path.dart';

abstract class AppPages {
  AppPages._();

  static final routes = [
    GetPage(name: RoutePath.HOME_PAGE, page: () => const HomePage(), binding: HomeBinding()),
    GetPage(name: RoutePath.LOGIN_PAGE, page: () => const LoginPage(), binding: LoginBinding()),
    GetPage(name: RoutePath.REGISTER_PAGE, page: () => const RegisterPage(), binding: RegisterBinding()),
    GetPage(name: RoutePath.MY_INFO_PAGE, page: () => const PersonalPage(), binding: PersonalBinding()),
    GetPage(name: RoutePath.SETTING_PAGE, page: () => const SettingPage(), binding: SettingBinding()),
    GetPage(name: RoutePath.LANGUAGE_PAGE, page: () => const LanguagePage(), binding: LanguageBinding()),
    GetPage(name: RoutePath.ACCOUNT_PAGE, page: () => const AccountPage(), binding: AccountBinding()),
    GetPage(name: RoutePath.LINE_PAGE, page: () => const LinePage(), binding: LineBinding()),
    GetPage(name: RoutePath.PRIVACY_PAGE, page: () => const PrivacyPage(), binding: PrivacyBinding()),
    GetPage(name: RoutePath.WINDOWS_PAGE, page: () => const WindowsPage(), binding: WindowsBinding()),
    GetPage(
        name: RoutePath.SELECT_CONTACTS_PAGE, page: () => const SelectContactsPage(), binding: SelectContactsBinding()),
    GetPage(
        name: RoutePath.SESSION_DETAIL_PAGE,
        page: () => SessionDetailPage(tag: "${Get.arguments[Keys.ID]}"),
        binding: SessionDetailBinding()),
    GetPage(name: RoutePath.CHAT_PAGE, page: () => ChatPage(tag: "${Get.arguments[Keys.ID]}"), binding: ChatBinding()),
  ];
}
