import 'package:json_annotation/json_annotation.dart';

part 'rate_entity.g.dart';

@JsonSerializable()
class RateEntity {
  int? id;
  String? label;
  double? value;
  int status;
  int type;

  RateEntity({this.id, this.label, this.value, this.status = 0, this.type = 0});

  factory RateEntity.fromJson(Map<String, dynamic> json) => _$RateEntityFromJson(json);

  Map<String, dynamic> toJson() => _$RateEntityToJson(this);
}

@JsonSerializable()
class ImConfigEntity {
  int? id;
  String? label;
  String? value;
  int type;

  ImConfigEntity({this.id, this.label, this.value, this.type = 0});

  factory ImConfigEntity.fromJson(Map<String, dynamic> json) => _$ImConfigEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ImConfigEntityToJson(this);
}
