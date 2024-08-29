import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'mine': 'Mine',
          'message': 'Message',
          'id': 'ID NO.：@number',
          'other': 'Other functions',
          'language_setting': 'Language Setting',
          'language': 'Language',
          'device': 'device',
          'privacy': 'privacy',
          'privacy_setting': 'privacy setting',
        },
        'zh_CN': {
          'mine': '我的',
          'message': '消息',
          'id': 'ID号：@number',
          'other': '其他功能',
          'language_setting': '语言设置',
          'language': '语言',
          'device': '设备',
          'privacy': '隐私',
          'privacy_setting': '隐私设置',
        },
        'zh_HK': {
          'mine': '我的',
          'message': '消息',
          'id': 'ID号：@number',
          'other': '其他功能',
          'language_setting': '语言设置',
          'language': '语言',
          'device': '设备',
          'privacy': '隐私',
          'privacy_setting': '隐私设置',
        }
      };
}
