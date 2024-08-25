import 'package:json_annotation/json_annotation.dart';

part 'base64.g.dart';

@JsonSerializable()
class Base64Entity {
  String? img;
  String? uuid;

  Base64Entity({this.img, this.uuid});

  factory Base64Entity.fromJson(Map<String, dynamic> json) => _$Base64EntityFromJson(json);

  Map<String, dynamic> toJson() => _$Base64EntityToJson(this);
}
