import 'package:realm/realm.dart';
import 'package:vura/entities/account_entity.dart';
import 'package:vura/realm/account.dart';

import 'log_utils.dart';

class AccountRealm {
  final Realm _realm;

  AccountRealm({required Realm realm}) : _realm = realm;

  /// 查询所有
  Future<List<AccountEntity>> queryAllAccounts() async {
    Log.d("queryAllAccounts=====================");
    return _realm.all<Account>().map((item) => accountRealmToEntity(item)).toList();
  }

  /// 更新/插入数据
  Future<Account> upsert(Account account) async {
    return await _realm.writeAsync(() {
      Log.d("upsert----account------------->${account.userName}");
      return _realm.add(account, update: true);
    });
  }

  Account? findOne(String? userName) {
    return _realm.find<Account>(userName);
  }

  /// 更新信息
  Future update(AccountEntity account) async {
    Account? _account = findOne(account.userName);
    if (_account != null) {
      await _realm.writeAsync(() {
        _account.nickName = account.nickName;
        _account.headImage = account.headImage;
        _account.headImageThumb = account.headImageThumb;
        _account.userNo = account.userNo;
      });

      Log.d("update===================>${_account.toEJson()}");
    }
  }
}

AccountEntity accountRealmToEntity(Account account) {
  return AccountEntity(
      userName: account.userName,
      nickName: account.nickName,
      password: account.password,
      headImage: account.headImage,
      userNo: account.userNo,
      headImageThumb: account.headImageThumb);
}

Account accountEntityToRealm(AccountEntity account) {
  return Account(account.userName,
      nickName: account.nickName,
      password: account.password,
      headImage: account.headImage,
      userNo: account.userNo,
      headImageThumb: account.headImageThumb);
}
