import 'package:equatable/equatable.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

class CreatePaymentEvent extends PaymentEvent {
  final String orderId;
  final String orderInfo;
  final String amount;
  final String returnUrl;

  const CreatePaymentEvent({
    required this.orderId,
    required this.orderInfo,
    required this.amount,
    required this.returnUrl,
  });

  @override
  List<Object> get props => [orderId, orderInfo, amount, returnUrl];
}