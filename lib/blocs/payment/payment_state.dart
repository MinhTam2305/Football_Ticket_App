abstract class PaymentState {}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentSuccess extends PaymentState {
  final String paymentUrl;
  PaymentSuccess(this.paymentUrl);
}

class PaymentFailure extends PaymentState {
  final String error;
  PaymentFailure(this.error);
}