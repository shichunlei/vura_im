import 'package:get/get.dart';
import 'package:vura/global/keys.dart';
import 'package:vura/modules/contacts/add_friend/binding.dart';
import 'package:vura/modules/contacts/add_friend/page.dart';
import 'package:vura/modules/contacts/blacklist/binding.dart';
import 'package:vura/modules/contacts/blacklist/page.dart';
import 'package:vura/modules/contacts/new_friend/binding.dart';
import 'package:vura/modules/contacts/new_friend/page.dart';
import 'package:vura/modules/contacts/phone_contacts/binding.dart';
import 'package:vura/modules/contacts/phone_contacts/page.dart';
import 'package:vura/modules/contacts/select/binding.dart';
import 'package:vura/modules/contacts/select/page.dart';
import 'package:vura/modules/dashboard/devices/binding.dart';
import 'package:vura/modules/dashboard/devices/page.dart';
import 'package:vura/modules/dashboard/google_verify/binding.dart';
import 'package:vura/modules/dashboard/google_verify/page.dart';
import 'package:vura/modules/dashboard/language/binding.dart';
import 'package:vura/modules/dashboard/language/page.dart';
import 'package:vura/modules/dashboard/notice_setting/binding.dart';
import 'package:vura/modules/dashboard/notice_setting/page.dart';
import 'package:vura/modules/dashboard/privacy/home/binding.dart';
import 'package:vura/modules/dashboard/privacy/home/page.dart';
import 'package:vura/modules/dashboard/privacy/lock_screen_password/binding.dart';
import 'package:vura/modules/dashboard/privacy/lock_screen_password/page.dart';
import 'package:vura/modules/dashboard/privacy/pay_password/binding.dart';
import 'package:vura/modules/dashboard/privacy/pay_password/page.dart';
import 'package:vura/modules/dashboard/privacy/set_gesture_password/binding.dart';
import 'package:vura/modules/dashboard/privacy/set_gesture_password/page.dart';
import 'package:vura/modules/dashboard/privacy/set_number_password/binding.dart';
import 'package:vura/modules/dashboard/privacy/set_number_password/page.dart';
import 'package:vura/modules/dashboard/windows/chat_background/binding.dart';
import 'package:vura/modules/dashboard/windows/chat_background/page.dart';
import 'package:vura/modules/dashboard/windows/font_size_setting/binding.dart';
import 'package:vura/modules/dashboard/windows/font_size_setting/page.dart';
import 'package:vura/modules/dashboard/windows/home/binding.dart';
import 'package:vura/modules/dashboard/windows/home/page.dart';
import 'package:vura/modules/finance/add_way/binding.dart';
import 'package:vura/modules/finance/add_way/page.dart';
import 'package:vura/modules/finance/charge/binding.dart';
import 'package:vura/modules/finance/charge/page.dart';
import 'package:vura/modules/finance/charge_way/binding.dart';
import 'package:vura/modules/finance/charge_way/page.dart';
import 'package:vura/modules/finance/recharge/binding.dart';
import 'package:vura/modules/finance/recharge/page.dart';
import 'package:vura/modules/finance/transfer/binding.dart';
import 'package:vura/modules/finance/transfer/page.dart';
import 'package:vura/modules/finance/wallet/binding.dart';
import 'package:vura/modules/finance/wallet/page.dart';
import 'package:vura/modules/finance/withdraw/binding.dart';
import 'package:vura/modules/finance/withdraw/page.dart';
import 'package:vura/modules/home/binding.dart';
import 'package:vura/modules/home/page.dart';
import 'package:vura/modules/im/chat/binding.dart';
import 'package:vura/modules/im/chat/page.dart';
import 'package:vura/modules/im/mute/binding.dart';
import 'package:vura/modules/im/mute/page.dart';
import 'package:vura/modules/im/session_detail/group/binding.dart';
import 'package:vura/modules/im/session_detail/group/page.dart';
import 'package:vura/modules/im/session_detail/private/binding.dart';
import 'package:vura/modules/im/session_detail/private/page.dart';
import 'package:vura/modules/im/session_manager/binding.dart';
import 'package:vura/modules/im/session_manager/page.dart';
import 'package:vura/modules/im/session_member/binding.dart';
import 'package:vura/modules/im/session_member/page.dart';
import 'package:vura/modules/im/session_members/binding.dart';
import 'package:vura/modules/im/session_members/page.dart';
import 'package:vura/modules/im/session_supadmin/binding.dart';
import 'package:vura/modules/im/session_supadmin/page.dart';
import 'package:vura/modules/im/sessions/binding.dart';
import 'package:vura/modules/im/sessions/page.dart';
import 'package:vura/modules/package/publish/binding.dart';
import 'package:vura/modules/package/publish/page.dart';
import 'package:vura/modules/package/result/binding.dart';
import 'package:vura/modules/package/result/page.dart';
import 'package:vura/modules/setting/account/binding.dart';
import 'package:vura/modules/setting/account/page.dart';
import 'package:vura/modules/setting/home/binding.dart';
import 'package:vura/modules/setting/home/page.dart';
import 'package:vura/modules/setting/line/binding.dart';
import 'package:vura/modules/setting/line/page.dart';
import 'package:vura/modules/user/info/binding.dart';
import 'package:vura/modules/user/info/page.dart';
import 'package:vura/modules/user/lock_screen/binding.dart';
import 'package:vura/modules/user/lock_screen/page.dart';
import 'package:vura/modules/user/login/binding.dart';
import 'package:vura/modules/user/login/page.dart';
import 'package:vura/modules/user/my_qr_code/binding.dart';
import 'package:vura/modules/user/my_qr_code/page.dart';
import 'package:vura/modules/user/personal/binding.dart';
import 'package:vura/modules/user/personal/page.dart';
import 'package:vura/modules/user/register/binding.dart';
import 'package:vura/modules/user/register/page.dart';
import 'package:vura/modules/user/set_password/binding.dart';
import 'package:vura/modules/user/set_password/page.dart';
import 'package:vura/modules/user/update_password/binding.dart';
import 'package:vura/modules/user/update_password/page.dart';
import 'package:vura/route/route_path.dart';

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
    GetPage(
        name: RoutePath.NOTICE_SETTING_PAGE, page: () => const NoticeSettingPage(), binding: NoticeSettingBinding()),
    GetPage(
        name: RoutePath.CHAT_BACKGROUND_PAGE, page: () => const ChatBackgroundPage(), binding: ChatBackgroundBinding()),
    GetPage(name: RoutePath.PAY_PASSWORD_PAGE, page: () => const PayPasswordPage(), binding: PayPasswordBinding()),
    GetPage(
        name: RoutePath.PHONE_CONTACTS_PAGE, page: () => const PhoneContactsPage(), binding: PhoneContactsBinding()),
    GetPage(
        name: RoutePath.LOCK_SCREEN_PASSWORD_PAGE,
        page: () => const LockScreenPasswordPage(),
        binding: LockScreenPasswordBinding()),
    GetPage(
        name: RoutePath.GESTURE_PASSWORD_PAGE,
        page: () => const SetGesturePasswordPage(),
        binding: SetGesturePasswordBinding()),
    GetPage(
        name: RoutePath.NUMBER_PASSWORD_PAGE,
        page: () => const SetNumberPasswordPage(),
        binding: SetNumberPasswordBinding()),
    GetPage(name: RoutePath.LOCK_SCREEN_PAGE, page: () => const LockScreenPage(), binding: LockScreenBinding()),
    GetPage(name: RoutePath.FONT_SIZE_PAGE, page: () => const FontSizeSettingPage(), binding: FontSizeSettingBinding()),
    GetPage(name: RoutePath.CHARGE_PAGE, page: () => const ChargePage(), binding: ChargeBinding()),
    GetPage(name: RoutePath.CHARGE_WAY_PAGE, page: () => const ChargeWayPage(), binding: ChargeWayBinding()),
    GetPage(name: RoutePath.ADD_CHARGE_WAY_PAGE, page: () => const AddWayPage(), binding: AddWayBinding()),
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
    GetPage(name: RoutePath.WALLET_PAGE, page: () => const WalletPage(), binding: WalletBinding()),
    GetPage(name: RoutePath.RECHARGE_PAGE, page: () => const RechargePage(), binding: RechargeBinding()),
    GetPage(name: RoutePath.WITHDRAW_PAGE, page: () => const WithdrawPage(), binding: WithdrawBinding()),
  ];
}
