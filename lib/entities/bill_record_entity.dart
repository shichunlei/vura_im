import 'package:json_annotation/json_annotation.dart';
import 'package:vura/global/enum.dart';

part 'bill_record_entity.g.dart';

@JsonSerializable()
class BillRecordEntity {
  String? id;
  BookType categoryCode;
  String? categoryName;
  String? userId;
  String? avatarUrl;
  double money;
  double rmb;
  String? remark;
  String? walletRemark;
  String? nickName;
  String? walletCard;
  FeeType type;
  String? detailDesc;
  String? updateTime;
  int updateTimeStamp;

  BillRecordEntity(
      {this.id,
      this.categoryCode = BookType.RED,
      this.categoryName,
      this.userId,
      this.avatarUrl,
      this.money = .0,
      this.rmb = .0,
      this.remark,
      this.walletRemark,
      this.nickName,
      this.walletCard,
      this.type = FeeType.PAY,
      this.detailDesc,
      this.updateTime,
      this.updateTimeStamp = 0});

  factory BillRecordEntity.fromJson(Map<String, dynamic> json) => _$BillRecordEntityFromJson(json);

  Map<String, dynamic> toJson() => _$BillRecordEntityToJson(this);
}
