import 'package:json_annotation/json_annotation.dart';
import 'package:vura/global/enum.dart';

part 'message_entity.g.dart';

@JsonSerializable()
class MessageEntity {
  String? id;
  @JsonKey(includeIfNull: false, name: "groupId")
  String? sessionId;
  String? groupName;
  @JsonKey(includeIfNull: false)
  String? sendId;
  @JsonKey(includeIfNull: false)
  String? sendNickName;
  @JsonKey(includeIfNull: false)
  String? sendHeadImage;
  @JsonKey(name: "recvId", includeIfNull: false)
  String? receiveId;
  @JsonKey(name: "recvNickName", includeIfNull: false)
  String? receiveNickName;
  @JsonKey(name: "recvHeadImage", includeIfNull: false)
  String? receiveHeadImage;
  @JsonKey(includeIfNull: false)
  String? content;
  int type;
  bool receipt;
  bool receiptOk;
  @JsonKey(name: "readedCount")
  int readCount;
  List<String?> atUserIds;
  int status;
  int sendTime;
  @JsonKey(includeFromJson: false, includeToJson: false)
  SessionType sessionType;

  MessageEntity({
    this.id,
    this.sessionId,
    this.groupName,
    this.sendId,
    this.receiveId,
    this.receiveNickName,
    this.receiveHeadImage,
    this.sendNickName,
    this.sendHeadImage,
    this.content,
    this.type = 0,
    this.receipt = false,
    this.receiptOk = false,
    this.readCount = 0,
    this.atUserIds = const [],
    this.status = 0,
    this.sendTime = 0,
    this.sessionType = SessionType.group,
  });

  factory MessageEntity.fromJson(Map<String, dynamic> json) => _$MessageEntityFromJson(json);

  Map<String, dynamic> toJson() => _$MessageEntityToJson(this);
}
