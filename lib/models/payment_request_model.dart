class PaymentRequestModel {
  final String userId;
  final int amount;
  final String description;

  PaymentRequestModel({
    required this.userId,
    required this.amount,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'amount': amount,
    'description': description,
  };
}