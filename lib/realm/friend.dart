import 'package:realm/realm.dart';

part 'friend.realm.dart';

@RealmModel()
class _Friend {
  @PrimaryKey()
  String? _id;
  String? id;
  String? userId;
  String? nickName;
  String? userName;
  int sex = -1;
  String? signature;
  String? headImage;
  String? headImageThumb;
  String? indexTag;
  bool isDeleted = false;
  String? friendship;
  String? userNo;
  int leaveTimeStamp = 0;
  bool online = false;
}
