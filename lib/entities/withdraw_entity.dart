import 'package:json_annotation/json_annotation.dart';

part 'withdraw_entity.g.dart';

@JsonSerializable()
class WithdrawEntity {
  String? id;
  double money; // 人民币
  int usdt; //

  WithdrawEntity({this.id, this.money = .0, this.usdt = 0});

  factory WithdrawEntity.fromJson(Map<String, dynamic> json) => _$WithdrawEntityFromJson(json);

  Map<String, dynamic> toJson() => _$WithdrawEntityToJson(this);

  static List<WithdrawEntity> getWithdraw(double rate) {
    return [
      WithdrawEntity(id: "1", usdt: 300, money: 300 * rate),
      WithdrawEntity(id: "2", usdt: 500, money: 500 * rate),
      WithdrawEntity(id: "3", usdt: 1000, money: 1000 * rate),
      WithdrawEntity(id: "4", usdt: 2000, money: 2000 * rate),
      WithdrawEntity(id: "5", usdt: 3000, money: 3000 * rate),
      WithdrawEntity(id: "6", usdt: 5000, money: 5000 * rate),
      WithdrawEntity(id: "7", usdt: 10000, money: 10000 * rate),
      WithdrawEntity(id: "8", usdt: 20000, money: 20000 * rate),
      WithdrawEntity(id: "9", usdt: 30000, money: 30000 * rate)
    ];
  }
}
