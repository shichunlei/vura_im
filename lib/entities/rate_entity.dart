import 'package:json_annotation/json_annotation.dart';

part 'rate_entity.g.dart';

@JsonSerializable()
class RateEntity {
  int? id;
  String? label;
  double? value;
  int status;

  RateEntity({this.id, this.label, this.value, this.status = 0});

  factory RateEntity.fromJson(Map<String, dynamic> json) => _$RateEntityFromJson(json);

  Map<String, dynamic> toJson() => _$RateEntityToJson(this);
}
