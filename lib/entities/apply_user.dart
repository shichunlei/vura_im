import 'package:json_annotation/json_annotation.dart';

part 'apply_user.g.dart';

@JsonSerializable()
class ApplyUserEntity {
  @JsonKey(includeIfNull: false)
  String? applyId;
  @JsonKey(includeIfNull: false)
  String? applySource;
  @JsonKey(includeIfNull: false)
  String? applyStatus; // 申请状态0无1同意2拒绝
  @JsonKey(includeIfNull: false)
  String? applyType; // 申请类型1好友2群组
  @JsonKey(includeIfNull: false)
  String? createTime;
  @JsonKey(includeIfNull: false)
  String? nickName;
  @JsonKey(includeIfNull: false)
  String? portrait;
  @JsonKey(includeIfNull: false)
  String? reason;
  @JsonKey(includeIfNull: false)
  String? userId;

  ApplyUserEntity({
    this.applyId,
    this.applySource,
    this.applyStatus,
    this.applyType,
    this.createTime,
    this.nickName,
    this.portrait,
    this.reason,
    this.userId,
  });

  factory ApplyUserEntity.fromJson(Map<String, dynamic> json) => _$ApplyUserEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ApplyUserEntityToJson(this);
}
