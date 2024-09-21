import 'package:json_annotation/json_annotation.dart';
import 'package:vura/global/enum.dart';

part 'red_package_result.g.dart';

@JsonSerializable()
class RedPackageResultEntity {
  String? userId;
  String? nickName;
  String? headImage;
  String? createDate;
  double amount;
  YorNType isMine;
  List<RedPackageResultEntity> detailList;
  String? senderNickName;
  String? senderUserId;
  String? senderHeadImage;
  double totalAmount;
  int totalPacket;
  int createTimestamp;
  YorNType isGreat;
  int totalTime;
  String? minesStr;
  int expireStatus;

  RedPackageResultEntity(
      {this.userId,
      this.nickName,
      this.headImage,
      this.createDate,
      this.amount = .0,
      this.isMine = YorNType.N,
      this.isGreat = YorNType.N,
      this.senderHeadImage,
      this.senderNickName,
      this.totalAmount = .0,
      this.totalPacket = 0,
      this.createTimestamp = 0,
      this.detailList = const [],
      this.totalTime = 0,
      this.minesStr,
      this.expireStatus = 0});

  factory RedPackageResultEntity.fromJson(Map<String, dynamic> json) => _$RedPackageResultEntityFromJson(json);

  Map<String, dynamic> toJson() => _$RedPackageResultEntityToJson(this);
}
