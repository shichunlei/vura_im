import 'package:azlistview_plus/azlistview_plus.dart';
import 'package:pinyin/pinyin.dart';
import 'package:vura/global/enum.dart';
import 'package:vura/utils/enum_to_string.dart';

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
  YorNType friendship;
  double money;
  YorNType addFriend;
  YorNType protect;
  YorNType search;
  YorNType setGroup;
  YorNType vura;
  String? walletCard; // 钱包地址
  String? walletRemark; // 钱包备注
  String? payPassword;
  String? cardId;

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
      this.friendship = YorNType.M,
      this.addFriend = YorNType.N,
      this.protect = YorNType.N,
      this.search = YorNType.N,
      this.setGroup = YorNType.N,
      this.vura = YorNType.N,
      this.money = .0,
      this.walletCard,
      this.walletRemark,
      this.payPassword,
      this.cardId});

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
        friendship: EnumToString.fromString(YorNType.values, json['friendship'], defaultValue: YorNType.M)!,
        headImageThumb: json['headImageThumb'] as String?,
        online: json['online'] as bool? ?? false,
        walletCard: json['walletCard'] as String?,
        walletRemark: json['walletRemark'] as String?,
        addFriend: EnumToString.fromString(YorNType.values, json['addFriend'], defaultValue: YorNType.N)!,
        protect: EnumToString.fromString(YorNType.values, json['protect'], defaultValue: YorNType.N)!,
        search: EnumToString.fromString(YorNType.values, json['search'], defaultValue: YorNType.N)!,
        setGroup: EnumToString.fromString(YorNType.values, json['setGroup'], defaultValue: YorNType.N)!,
        vura: EnumToString.fromString(YorNType.values, json['vura'], defaultValue: YorNType.N)!,
        payPassword: json['payPassword'] as String?,
        cardId: json['no'] as String?,
        tagIndex: tag);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userName': userName,
        'nickName': nickName,
        'sex': sex,
        'type': type,
        'signature': signature,
        'headImageThumb': headImageThumb,
        'headImage': headImage,
      };

  @override
  String getSuspensionTag() => tagIndex ?? "";
}
