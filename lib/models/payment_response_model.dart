class PaymentResponseModel {
  final String paymentUrl;

  PaymentResponseModel({required this.paymentUrl});

  factory PaymentResponseModel.fromJson(Map<String, dynamic> json) {
    return PaymentResponseModel(
      paymentUrl: json['paymentUrl'],
    );
  }
}