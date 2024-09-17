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
  bool moveTop = false; // 置顶
  int moveTopTime = AppConfig.DEFAULT_TOP_TIME; // 置顶时间
  bool isDisturb = false; // 免打扰
  String isAdmin = "N"; // 是否为群主
  String isSupAdmin = "N"; // 是为群管理
  String? config; // 群配置
  String friendship = "Y";
  int unReadCount = 0; // 未读数
  String? no; // 群编码
  String? draft; // 草稿
  bool isShowList = true;
}
