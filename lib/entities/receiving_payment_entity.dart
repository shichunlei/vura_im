import 'package:json_annotation/json_annotation.dart';

part 'receiving_payment_entity.g.dart';

@JsonSerializable()
class ReceivingPaymentEntity {
  String? walletRemark;
  String? walletCard;

  ReceivingPaymentEntity({
    this.walletRemark,
    this.walletCard,
  });

  factory ReceivingPaymentEntity.fromJson(Map<String, dynamic> json) => _$ReceivingPaymentEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ReceivingPaymentEntityToJson(this);
}
