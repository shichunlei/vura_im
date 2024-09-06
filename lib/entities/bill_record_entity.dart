import 'package:json_annotation/json_annotation.dart';
import 'package:vura/global/enum.dart';

part 'bill_record_entity.g.dart';

@JsonSerializable()
class BillRecordEntity {
  String? id;
  String? categoryCode;
  String? categoryName;
  String? userId;
  String? avatarUrl;
  double money;
  String? remark;
  String? walletRemark;
  String? nickName;
  String? walletCard;
  FeeType type;
  String? detailDesc;
  String? updateTime;

  BillRecordEntity({
    this.id,
    this.categoryCode,
    this.categoryName,
    this.userId,
    this.avatarUrl,
    this.money = .0,
    this.remark,
    this.walletRemark,
    this.nickName,
    this.walletCard,
    this.type = FeeType.PAY,
    this.detailDesc,
    this.updateTime,
  });

  factory BillRecordEntity.fromJson(Map<String, dynamic> json) => _$BillRecordEntityFromJson(json);

  Map<String, dynamic> toJson() => _$BillRecordEntityToJson(this);
}
