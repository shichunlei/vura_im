import 'package:json_annotation/json_annotation.dart';

part 'message_entity.g.dart';

@JsonSerializable()
class MessageEntity {
  int? id;
  int? groupId;
  int? sendId;
  @JsonKey(name: "recvId")
  int? receiveId;
  String? sendNickName;
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
    this.sendNickName,
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
