abstract class PaymentEvent {}

class PaymentRequested extends PaymentEvent {
  final String userId;
  final int amount;
  final String description;

  PaymentRequested({
    required this.userId,
    required this.amount,
    required this.description,
  });
}