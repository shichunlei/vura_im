import 'package:azlistview_plus/azlistview_plus.dart';
import 'package:pinyin/pinyin.dart';

class UserEntity extends ISuspensionBean {
  String? id;
  String? userName;
  String? nickName;
  int sex;
  int type;
  String? signature;
  String? headImage;
  String? headImageThumb;
  bool online;
  String? tagIndex;
  String? friendship;
  double money;

  UserEntity(
      {this.id,
      this.userName,
      this.nickName,
      this.sex = 1,
      this.type = 1,
      this.signature,
      this.headImage,
      this.headImageThumb,
      this.online = false,
      this.tagIndex,
      this.friendship,
      this.money = .0});

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    String nickName = json['nickName'] ?? "";

    String tag = RegExp("[A-Z]").hasMatch(RegExp("[A-Z\\d]").hasMatch(nickName.substring(0, 1).toUpperCase())
            ? nickName.substring(0, 1).toUpperCase()
            : PinyinHelper.getPinyinE(nickName).substring(0, 1).toUpperCase())
        ? RegExp("[A-Z\\d]").hasMatch(nickName.substring(0, 1).toUpperCase())
            ? nickName.substring(0, 1).toUpperCase()
            : PinyinHelper.getPinyinE(nickName).substring(0, 1).toUpperCase()
        : "#";

    return UserEntity(
        id: json['id'] as String?,
        userName: json['userName'] as String?,
        nickName: nickName,
        sex: (json['sex'] as num?)?.toInt() ?? 1,
        type: (json['type'] as num?)?.toInt() ?? 1,
        money: (json['money'] as num?)?.toDouble() ?? .0,
        signature: json['signature'] as String?,
        headImage: json['headImage'] as String?,
        friendship: json['friendship'] as String?,
        headImageThumb: json['headImageThumb'] as String?,
        online: json['online'] as bool? ?? false,
        tagIndex: tag);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userName': userName,
        'nickName': nickName,
        'sex': sex,
        'type': type,
        'signature': signature,
        'online': online,
        'headImageThumb': headImageThumb,
        'headImage': headImage,
        'tagIndex': tagIndex,
        'friendship': friendship,
        "money": money,
      };

  @override
  String getSuspensionTag() => tagIndex ?? "";
}
