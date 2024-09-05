import 'package:json_annotation/json_annotation.dart';

part 'file_entity.g.dart';

@JsonSerializable()
class ImageEntity {
  String? originUrl;
  String? thumbUrl;

  ImageEntity({this.originUrl, this.thumbUrl});

  factory ImageEntity.fromJson(Map<String, dynamic> json) => _$ImageEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ImageEntityToJson(this);
}

@JsonSerializable()
class AudioEntity {
  String? fileUrl;
  int duration;

  AudioEntity({this.fileUrl, this.duration = 0});

  factory AudioEntity.fromJson(Map<String, dynamic> json) => _$AudioEntityFromJson(json);

  Map<String, dynamic> toJson() => _$AudioEntityToJson(this);
}
