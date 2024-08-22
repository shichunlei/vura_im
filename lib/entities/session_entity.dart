import 'package:im/entities/message_entity.dart';
import 'package:im/global/enum.dart';
import 'package:json_annotation/json_annotation.dart';

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
  bool isAdmin; // 群主
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

  SessionEntity({
    this.id,
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
    this.isAdmin = true,
    this.isSupAdmin = YorNType.N,
    this.type = SessionType.group,
    this.moveTop = false,
    this.isDisturb = false,
    this.lastMessage,
    this.lastMessageTime = 0,
    this.friendIds = const [],
  });

  factory SessionEntity.fromJson(Map<String, dynamic> json) => _$SessionEntityFromJson(json);

  Map<String, dynamic> toJson() => _$SessionEntityToJson(this);
}
