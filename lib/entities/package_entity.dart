import 'package:json_annotation/json_annotation.dart';

part 'package_entity.g.dart';

@JsonSerializable()
class RedPackageEntity {
  String? id;
  int type;
  String? userId;
  String? receiverId;
  num totalAmount;
  int totalPacket;
  String? blessing;
  String? cover;
  int leftAmount;
  int leftPacket;
  String? expireTime;
  int status;
  String? createDate;
  String? updateDate;
  int isValid;
  String? minesStr;
  List<int> mines;

  RedPackageEntity(
      {this.id,
      this.type = 2,
      this.userId,
      this.receiverId,
      this.totalAmount = .0,
      this.totalPacket = 1,
      this.blessing,
      this.cover,
      this.leftAmount = 0,
      this.leftPacket = 0,
      this.expireTime,
      this.status = 1,
      this.createDate,
      this.updateDate,
      this.isValid = 0,
      this.minesStr,
      this.mines = const []});

  factory RedPackageEntity.fromJson(Map<String, dynamic> json) => _$RedPackageEntityFromJson(json);

  Map<String, dynamic> toJson() => _$RedPackageEntityToJson(this);
}
