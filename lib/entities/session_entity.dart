import 'package:im/entities/message_entity.dart';
import 'package:im/global/enum.dart';
import 'package:json_annotation/json_annotation.dart';

part 'session_entity.g.dart';

@JsonSerializable()
class SessionEntity {
  @JsonKey(includeIfNull: false)
  int? id;
  @JsonKey(includeIfNull: false)
  String? name;
  @JsonKey(includeIfNull: false)
  int? ownerId;
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
  @JsonKey(includeFromJson: false)
  SessionType type;
  @JsonKey(includeFromJson: false)
  bool moveTop;
  @JsonKey(includeFromJson: false)
  MessageEntity? lastMessage;
  @JsonKey(includeFromJson: false)
  int lastMessageTime;

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
    this.type = SessionType.group,
    this.moveTop = false,
    this.lastMessage,
    this.lastMessageTime = 0,
  });

  factory SessionEntity.fromJson(Map<String, dynamic> json) => _$SessionEntityFromJson(json);

  Map<String, dynamic> toJson() => _$SessionEntityToJson(this);
}
