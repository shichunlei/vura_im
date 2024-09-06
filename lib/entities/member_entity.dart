import 'package:json_annotation/json_annotation.dart';
import 'package:vura/global/enum.dart';

part 'member_entity.g.dart';

@JsonSerializable()
class MemberEntity {
  @JsonKey(includeIfNull: false)
  String? userId;
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
  @JsonKey(includeIfNull: false)
  YorNType isAdmin;
  @JsonKey(includeIfNull: false)
  YorNType isSupAdmin;
  YorNType friendship;
  YorNType isMute;
  int isReceiveRedPacket; // 可以抢红包 0可以  1不可以
  String? userNo;

  MemberEntity({
    this.userId,
    this.showNickName,
    this.remarkNickName,
    this.headImage,
    this.quit = false,
    this.online = false,
    this.showGroupName,
    this.remarkGroupName,
    this.isAdmin = YorNType.N,
    this.isSupAdmin = YorNType.N,
    this.friendship = YorNType.M,
    this.isMute = YorNType.N,
    this.isReceiveRedPacket = 0,
    this.userNo,
  });

  factory MemberEntity.fromJson(Map<String, dynamic> json) => _$MemberEntityFromJson(json);

  Map<String, dynamic> toJson() => _$MemberEntityToJson(this);
}
