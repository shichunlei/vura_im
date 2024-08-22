import 'package:json_annotation/json_annotation.dart';

part 'file_entity.g.dart';

@JsonSerializable()
class FileEntity {
  String? originUrl;
  String? thumbUrl;

  FileEntity({this.originUrl, this.thumbUrl});

  factory FileEntity.fromJson(Map<String, dynamic> json) => _$FileEntityFromJson(json);

  Map<String, dynamic> toJson() => _$FileEntityToJson(this);
}
