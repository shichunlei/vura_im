import 'package:json_annotation/json_annotation.dart';

part 'message_entity.g.dart';

@JsonSerializable()
class MessageEntity {
  int? id;
  @JsonKey(includeIfNull: false)
  int? groupId;
  @JsonKey(includeIfNull: false)
  int? sendId;
  @JsonKey(includeIfNull: false)
  String? sendNickName;
  @JsonKey(includeIfNull: false)
  String? sendHeadImage;
  @JsonKey(name: "recvId", includeIfNull: false)
  int? receiveId;
  @JsonKey(includeIfNull: false)
  String? receiveNickName;
  @JsonKey(includeIfNull: false)
  String? receiveHeadImage;
  @JsonKey(includeIfNull: false)
  String? content;
  int type;
  bool receipt;
  bool receiptOk;
  @JsonKey(name: "readedCount")
  int readCount;
  List<int> atUserIds;
  int status;
  int sendTime;

  MessageEntity({
    this.id,
    this.groupId,
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
  });

  factory MessageEntity.fromJson(Map<String, dynamic> json) => _$MessageEntityFromJson(json);

  Map<String, dynamic> toJson() => _$MessageEntityToJson(this);
}
