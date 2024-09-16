import 'package:json_annotation/json_annotation.dart';

part 'device_entity.g.dart';

@JsonSerializable()
class DeviceEntity {
  String? id;
  String? userId;
  String? deviceId;
  String? deviceName;
  int createTime;
  int updateTime;

  DeviceEntity({this.id, this.userId, this.deviceId, this.deviceName, this.createTime = 0, this.updateTime = 0});

  factory DeviceEntity.fromJson(Map<String, dynamic> json) => _$DeviceEntityFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceEntityToJson(this);
}
