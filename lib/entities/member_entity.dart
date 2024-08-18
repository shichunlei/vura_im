import 'package:json_annotation/json_annotation.dart';

part 'member_entity.g.dart';

@JsonSerializable()
class MemberEntity {
  @JsonKey(includeIfNull: false)
  int? userId;
  @JsonKey(includeIfNull: false)
  String? showNickName;
  @JsonKey(includeIfNull: false)
  String? remarkNickName;
  @JsonKey(includeIfNull: false)
  String? headImage;
  bool quit;
  bool online;
  @JsonKey(includeIfNull: false)
  String? showGroupName;
  @JsonKey(includeIfNull: false)
  String? remarkGroupName;

  MemberEntity({
    this.userId,
    this.showNickName,
    this.remarkNickName,
    this.headImage,
    this.quit = false,
    this.online = false,
    this.showGroupName,
    this.remarkGroupName,
  });

  factory MemberEntity.fromJson(Map<String, dynamic> json) => _$MemberEntityFromJson(json);

  Map<String, dynamic> toJson() => _$MemberEntityToJson(this);
}
