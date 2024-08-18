import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'mine': 'Mine',
          'message': 'Message',
          'id': 'ID NO.：@number',
          'other': 'Other functions',
        },
        'zh_CN': {
          'mine': '我的',
          'message': '消息',
          'id': 'ID号：@number',
          'other': '其他功能',
        }
      };
}
