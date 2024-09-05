import 'package:json_annotation/json_annotation.dart';
import 'package:vura/entities/message_entity.dart';
import 'package:vura/global/enum.dart';

part 'session_entity.g.dart';

@JsonSerializable()
class SessionEntity {
  @JsonKey(includeIfNull: false)
  String? id;
  @JsonKey(includeIfNull: false)
  String? name;
  @JsonKey(includeIfNull: false)
  String? ownerId;
  @JsonKey(includeIfNull: false)
  String? headImage;
  @JsonKey(includeIfNull: false)
  String? headImageThumb;
  @JsonKey(includeIfNull: false)
  String? notice;
  @JsonKey(includeIfNull: false)
  String? remarkNickName;
  @JsonKey(includeIfNull: false)
  String? showNickName;
  @JsonKey(includeIfNull: false)
  String? showGroupName;
  @JsonKey(includeIfNull: false)
  String? remarkGroupName;
  bool deleted;
  bool quit;
  YorNType isAdmin; // 群主
  YorNType isSupAdmin; // 管理员
  @JsonKey(includeFromJson: false)
  SessionType type;
  @JsonKey(includeFromJson: false)
  bool moveTop;
  @JsonKey(includeFromJson: false)
  bool isDisturb;
  @JsonKey(includeFromJson: false)
  MessageEntity? lastMessage;
  @JsonKey(includeFromJson: false)
  int lastMessageTime;
  List<String> friendIds;
  SessionConfigEntity? configObj;
  String? config;
  YorNType friendship;
  @JsonKey(includeFromJson: false, includeToJson: false)
  int unReadCount = 0;

  SessionEntity(
      {this.id,
      this.name,
      this.ownerId,
      this.headImage,
      this.headImageThumb,
      this.notice,
      this.remarkNickName,
      this.showNickName,
      this.showGroupName,
      this.remarkGroupName,
      this.deleted = false,
      this.quit = false,
      this.isAdmin = YorNType.N,
      this.isSupAdmin = YorNType.N,
      this.type = SessionType.group,
      this.moveTop = false,
      this.isDisturb = false,
      this.lastMessage,
      this.lastMessageTime = 0,
      this.friendIds = const [],
      this.configObj,
      this.config,
      this.friendship = YorNType.Y,
      this.unReadCount = 0});

  factory SessionEntity.fromJson(Map<String, dynamic> json) => _$SessionEntityFromJson(json);

  Map<String, dynamic> toJson() => _$SessionEntityToJson(this);
}

@JsonSerializable()
class SessionConfigEntity {
  YorNType addFriend; // 禁止群成员加好友
  YorNType allMute; // 全体禁言
  YorNType vura; // 禁止领红包
  YorNType invite; // 邀请确认
  String? id;

  SessionConfigEntity(
      {this.id,
      this.addFriend = YorNType.N,
      this.allMute = YorNType.N,
      this.vura = YorNType.N,
      this.invite = YorNType.N});

  factory SessionConfigEntity.fromJson(Map<String, dynamic> json) => _$SessionConfigEntityFromJson(json);

  Map<String, dynamic> toJson() => _$SessionConfigEntityToJson(this);
}
