import 'package:json_annotation/json_annotation.dart';
import 'package:vura/global/enum.dart';

part 'red_package_result.g.dart';

@JsonSerializable()
class RedPackageResultEntity {
  String? userId;
  String? nickName;
  String? createDate;
  double amount;
  YorNType isMine;
  List<RedPackageResultEntity> detailList;

  RedPackageResultEntity(
      {this.userId,
      this.nickName,
      this.createDate,
      this.amount = .0,
      this.isMine = YorNType.N,
      this.detailList = const []});

  factory RedPackageResultEntity.fromJson(Map<String, dynamic> json) => _$RedPackageResultEntityFromJson(json);

  Map<String, dynamic> toJson() => _$RedPackageResultEntityToJson(this);
}
