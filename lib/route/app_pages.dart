import 'package:get/get.dart';
import 'package:im/global/keys.dart';
import 'package:im/modules/account/binding.dart';
import 'package:im/modules/account/page.dart';
import 'package:im/modules/add_friend/binding.dart';
import 'package:im/modules/add_friend/page.dart';
import 'package:im/modules/blacklist/binding.dart';
import 'package:im/modules/blacklist/page.dart';
import 'package:im/modules/charge/binding.dart';
import 'package:im/modules/charge/page.dart';
import 'package:im/modules/charge_way/binding.dart';
import 'package:im/modules/charge_way/page.dart';
import 'package:im/modules/chat/binding.dart';
import 'package:im/modules/chat/page.dart';
import 'package:im/modules/devices/binding.dart';
import 'package:im/modules/devices/page.dart';
import 'package:im/modules/google_verify/binding.dart';
import 'package:im/modules/google_verify/page.dart';
import 'package:im/modules/home/binding.dart';
import 'package:im/modules/home/page.dart';
import 'package:im/modules/language/binding.dart';
import 'package:im/modules/language/page.dart';
import 'package:im/modules/line/binding.dart';
import 'package:im/modules/line/page.dart';
import 'package:im/modules/login/binding.dart';
import 'package:im/modules/login/page.dart';
import 'package:im/modules/mute/binding.dart';
import 'package:im/modules/mute/page.dart';
import 'package:im/modules/my_qr_code/binding.dart';
import 'package:im/modules/my_qr_code/page.dart';
import 'package:im/modules/new_friend/binding.dart';
import 'package:im/modules/new_friend/page.dart';
import 'package:im/modules/package/publish/binding.dart';
import 'package:im/modules/package/publish/page.dart';
import 'package:im/modules/package/result/binding.dart';
import 'package:im/modules/package/result/page.dart';
import 'package:im/modules/personal/binding.dart';
import 'package:im/modules/personal/page.dart';
import 'package:im/modules/privacy/binding.dart';
import 'package:im/modules/privacy/page.dart';
import 'package:im/modules/register/binding.dart';
import 'package:im/modules/register/page.dart';
import 'package:im/modules/select_contacts/binding.dart';
import 'package:im/modules/select_contacts/page.dart';
import 'package:im/modules/session_detail/group/binding.dart';
import 'package:im/modules/session_detail/group/page.dart';
import 'package:im/modules/session_detail/private/binding.dart';
import 'package:im/modules/session_detail/private/page.dart';
import 'package:im/modules/session_manager/binding.dart';
import 'package:im/modules/session_manager/page.dart';
import 'package:im/modules/session_member/binding.dart';
import 'package:im/modules/session_member/page.dart';
import 'package:im/modules/session_members/binding.dart';
import 'package:im/modules/session_members/page.dart';
import 'package:im/modules/session_supadmin/binding.dart';
import 'package:im/modules/session_supadmin/page.dart';
import 'package:im/modules/sessions/binding.dart';
import 'package:im/modules/sessions/page.dart';
import 'package:im/modules/set_password/binding.dart';
import 'package:im/modules/set_password/page.dart';
import 'package:im/modules/setting/binding.dart';
import 'package:im/modules/setting/page.dart';
import 'package:im/modules/transfer/binding.dart';
import 'package:im/modules/transfer/page.dart';
import 'package:im/modules/update_password/binding.dart';
import 'package:im/modules/update_password/page.dart';
import 'package:im/modules/user_info/binding.dart';
import 'package:im/modules/user_info/page.dart';
import 'package:im/modules/windows/binding.dart';
import 'package:im/modules/windows/page.dart';
import 'package:im/route/route_path.dart';

abstract class AppPages {
  AppPages._();

  static final routes = [
    GetPage(name: RoutePath.HOME_PAGE, page: () => const HomePage(), binding: HomeBinding()),
    GetPage(name: RoutePath.LOGIN_PAGE, page: () => const LoginPage(), binding: LoginBinding()),
    GetPage(name: RoutePath.REGISTER_PAGE, page: () => const RegisterPage(), binding: RegisterBinding()),
    GetPage(
        name: RoutePath.UPDATE_PASSWORD_PAGE, page: () => const UpdatePasswordPage(), binding: UpdatePasswordBinding()),
    GetPage(name: RoutePath.SET_PASSWORD_PAGE, page: () => const SetPasswordPage(), binding: SetPasswordBinding()),
    GetPage(name: RoutePath.MY_INFO_PAGE, page: () => const PersonalPage(), binding: PersonalBinding()),
    GetPage(name: RoutePath.SETTING_PAGE, page: () => const SettingPage(), binding: SettingBinding()),
    GetPage(name: RoutePath.LANGUAGE_PAGE, page: () => const LanguagePage(), binding: LanguageBinding()),
    GetPage(name: RoutePath.ACCOUNT_PAGE, page: () => const AccountPage(), binding: AccountBinding()),
    GetPage(name: RoutePath.LINE_PAGE, page: () => const LinePage(), binding: LineBinding()),
    GetPage(name: RoutePath.PRIVACY_PAGE, page: () => const PrivacyPage(), binding: PrivacyBinding()),
    GetPage(name: RoutePath.WINDOWS_PAGE, page: () => const WindowsPage(), binding: WindowsBinding()),
    GetPage(
        name: RoutePath.SELECT_CONTACTS_PAGE, page: () => const SelectContactsPage(), binding: SelectContactsBinding()),
    GetPage(name: RoutePath.DEVICES_PAGE, page: () => const DevicesPage(), binding: DevicesBinding()),
    GetPage(name: RoutePath.CHARGE_PAGE, page: () => const ChargePage(), binding: ChargeBinding()),
    GetPage(name: RoutePath.CHARGE_WAY_PAGE, page: () => const ChargeWayPage(), binding: ChargeWayBinding()),
    GetPage(name: RoutePath.TRANSFER_PAGE, page: () => const TransferPage(), binding: TransferBinding()),
    GetPage(
        name: RoutePath.GROUP_SESSION_DETAIL_PAGE,
        page: () => GroupSessionDetailPage(tag: Get.arguments[Keys.ID]),
        binding: GroupSessionDetailBinding()),
    GetPage(
        name: RoutePath.PRIVATE_SESSION_DETAIL_PAGE,
        page: () => PrivateSessionDetailPage(tag: Get.arguments[Keys.ID]),
        binding: PrivateSessionDetailBinding()),
    GetPage(name: RoutePath.CHAT_PAGE, page: () => ChatPage(tag: Get.arguments[Keys.ID]), binding: ChatBinding()),
    GetPage(
        name: RoutePath.SESSION_MEMBER_PAGE,
        page: () => SessionMemberPage(tag: Get.arguments[Keys.ID]),
        binding: SessionMemberBinding()),
    GetPage(
        name: RoutePath.SESSION_MEMBERS_PAGE,
        page: () => SessionMembersPage(tag: Get.arguments[Keys.ID]),
        binding: SessionMembersBinding()),
    GetPage(
        name: RoutePath.SESSION_MANAGER_PAGE,
        page: () => SessionManagerPage(tag: Get.arguments[Keys.ID]),
        binding: SessionManagerBinding()),
    GetPage(name: RoutePath.MUTE_PAGE, page: () => MutePage(tag: Get.arguments[Keys.ID]), binding: MuteBinding()),
    GetPage(name: RoutePath.BLACKLIST_PAGE, page: () => const BlacklistPage(), binding: BlacklistBinding()),
    GetPage(name: RoutePath.NEW_FRIEND_PAGE, page: () => const NewFriendPage(), binding: NewFriendBinding()),
    GetPage(name: RoutePath.ADD_FRIEND_PAGE, page: () => const AddFriendPage(), binding: AddFriendBinding()),
    GetPage(name: RoutePath.SESSIONS_PAGE, page: () => const SessionsPage(), binding: SessionsBinding()),
    GetPage(
        name: RoutePath.PACKAGE_RESULT_PAGE,
        page: () => PackageResultPage(tag: Get.arguments[Keys.ID]),
        binding: PackageResultBinding()),
    GetPage(
        name: RoutePath.PACKAGE_PUBLISH_PAGE, page: () => const PackagePublishPage(), binding: PackagePublishBinding()),
    GetPage(
        name: RoutePath.MY_QR_CODE_PAGE,
        page: () => MyQrCodePage(tag: Get.arguments[Keys.ID]),
        binding: MyQrCodeBinding()),
    GetPage(
        name: RoutePath.USER_INFO_PAGE,
        page: () => UserInfoPage(tag: Get.arguments[Keys.ID]),
        binding: UserInfoBinding()),
    GetPage(
        name: RoutePath.SESSION_SUP_ADMIN_PAGE,
        page: () => SessionSupAdminPage(tag: Get.arguments[Keys.ID]),
        binding: SessionSupAdminBinding()),
    GetPage(name: RoutePath.GOOGLE_VERIFY_PAGE, page: () => const GoogleVerifyPage(), binding: GoogleVerifyBinding()),
  ];
}
