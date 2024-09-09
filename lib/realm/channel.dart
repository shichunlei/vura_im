import 'package:realm/realm.dart';
import 'package:vura/global/config.dart';

part 'channel.realm.dart';

@RealmModel()
class _Channel {
  @PrimaryKey()
  late String _id;
  String? userId;
  String type = "group";
  String? id;
  String? name;
  String? ownerId;
  String? headImage;
  String? headImageThumb;
  String? notice;
  String? remarkNickName;
  String? showNickName;
  String? showGroupName;
  String? remarkGroupName;
  bool deleted = false;
  bool quit = false;
  String? lastMessage;
  int lastMessageTime = 0;
  bool moveTop = false;
  int moveTopTime = AppConfig.DEFAULT_TOP_TIME;
  bool isDisturb = false;
  String isAdmin = "N";
  String isSupAdmin = "N";
  String? config;
  String friendship = "Y";
  int unReadCount = 0;
  String? no;
}
