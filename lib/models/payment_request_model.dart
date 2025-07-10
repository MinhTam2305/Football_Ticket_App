class PaymentRequestModel {
  final String orderId;
  final String orderInfo;
  final String amount;
  final String returnUrl;

  PaymentRequestModel({
    required this.orderId,
    required this.orderInfo,
    required this.amount,
    required this.returnUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'orderInfo': orderInfo,
      'amount': amount,
      'returnUrl': returnUrl,
    };
  }
}