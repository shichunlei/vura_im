import 'package:json_annotation/json_annotation.dart';

part 'login_entity.g.dart';

@JsonSerializable()
class LoginEntity {
  String? accessToken;
  int accessTokenExpiresIn;
  String? refreshToken;
  int refreshTokenExpiresIn;

  LoginEntity(
      {this.accessToken, this.accessTokenExpiresIn = 1800, this.refreshToken, this.refreshTokenExpiresIn = 604800});

  factory LoginEntity.fromJson(Map<String, dynamic> json) => _$LoginEntityFromJson(json);

  Map<String, dynamic> toJson() => _$LoginEntityToJson(this);
}
