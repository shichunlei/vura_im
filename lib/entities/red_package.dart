import 'package:json_annotation/json_annotation.dart';
import 'package:vura/global/enum.dart';

part 'red_package.g.dart';

@JsonSerializable()
class RedPackage {
  String? redPacketId;
  int type;
  String? sendUserId;
  String? sendUserName;
  String? receiveUserId;
  double receiveAmount;
  String? blessing;
  String? cover;
  YorNType isMine;

  RedPackage({
    this.redPacketId,
    this.type = 1,
    this.sendUserId,
    this.sendUserName,
    this.receiveUserId,
    this.receiveAmount = .0,
    this.blessing,
    this.cover,
    this.isMine = YorNType.N,
  });

  factory RedPackage.fromJson(Map<String, dynamic> json) => _$RedPackageFromJson(json);

  Map<String, dynamic> toJson() => _$RedPackageToJson(this);
}
