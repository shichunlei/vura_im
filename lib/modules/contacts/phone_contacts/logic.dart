import 'package:fast_contacts/fast_contacts.dart';
import 'package:vura/base/base_list_logic.dart';
import 'package:vura/utils/log_utils.dart';

/// {"id":"1","phones":[{"number":"11 234 645 4484","label":"mobile"}],"emails":[{"address":"suuwu@qq.com","label":"home"}],"structuredName":{"displayName":"张三","namePrefix":"","givenName":"张三","middleName":"","familyName":"","nameSuffix":""},"organization":{"company":"微视听","department":"","jobDescription":""}}
class PhoneContactsLogic extends BaseListLogic<Contact> {
  @override
  void onInit() {
    initData();
    super.onInit();
  }

  @override
  Future<List<Contact>> loadData() async {
    return await FastContacts.getAllContacts();
  }

  @override
  void onCompleted(List<Contact> data) {
    for (var item in data) {
      Log.json(item.toMap());
    }
  }
}
