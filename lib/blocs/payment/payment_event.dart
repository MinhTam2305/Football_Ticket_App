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

class CompleteBookingAndRefreshTicketsEvent extends PaymentEvent {
  final String userId;
  final String matchId;
  final String standId;
  final int quantity; // ⚠️ Đã thêm quantity
  final String token;

  const CompleteBookingAndRefreshTicketsEvent({
    required this.userId,
    required this.matchId,
    required this.standId,
    required this.quantity,
    required this.token,
  });

  @override
  List<Object?> get props => [userId, matchId, standId, quantity, token];
}