import 'package:json_annotation/json_annotation.dart';

part 'package_entity.g.dart';

@JsonSerializable()
class PackageEntity {
  int? id;
  int? type;
  int? userId;
  int? receiverId;
  num? totalAmount;
  int totalPacket;
  String? blessing;
  String? cover;
  int? leftAmount;
  int? leftPacket;
  String? expireTime;
  int? status;
  String? createDate;
  String? updateDate;
  int? isValid;
  String? minesStr;

  PackageEntity({
    this.id,
    this.type,
    this.userId,
    this.receiverId,
    this.totalAmount,
    this.totalPacket=1,
    this.blessing,
    this.cover,
    this.leftAmount,
    this.leftPacket,
    this.expireTime,
    this.status,
    this.createDate,
    this.updateDate,
    this.isValid,
    this.minesStr,
  });

  factory PackageEntity.fromJson(Map<String, dynamic> json) => _$PackageEntityFromJson(json);

  Map<String, dynamic> toJson() => _$PackageEntityToJson(this);
}
