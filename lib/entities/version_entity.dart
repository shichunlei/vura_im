import 'package:json_annotation/json_annotation.dart';

part 'version_entity.g.dart';

@JsonSerializable()
class VersionEntity {
  @JsonKey(name: '_id')
  String? id;
  String? version;
  String? download;
  String changesText;
  int versionCode;
  bool forceUpdate;

  VersionEntity({
    this.id,
    this.version,
    this.download,
    this.changesText = "",
    this.versionCode = 1,
    this.forceUpdate = false,
  });

  factory VersionEntity.fromJson(Map<String, dynamic> json) => _$VersionEntityFromJson(json);

  Map<String, dynamic> toJson() => _$VersionEntityToJson(this);
}
