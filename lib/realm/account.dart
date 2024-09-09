import 'package:realm/realm.dart';

part 'account.realm.dart';

@RealmModel()
class _Account {
  @PrimaryKey()
  String? userName;
  String? nickName;
  String? password;
  String? headImage;
  String? headImageThumb;
  String? userNo;
}
