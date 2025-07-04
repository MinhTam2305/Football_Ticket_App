import 'dart:convert';
import 'package:http/http.dart' as http;
import '/models/payment_request_model.dart';

class PaymentRepository {
  final String baseUrl;
  PaymentRepository({required this.baseUrl});

  Future<String> createPayment({
    required String userId,
    required int amount,
    required String description,
  }) async {
    final url = Uri.parse('$baseUrl/api/Payment/create-payment');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(PaymentRequestModel(
        userId: userId,
        amount: amount,
        description: description,
      ).toJson()),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['paymentUrl'];
    } else {
      throw Exception('Failed to create payment');
    }
  }
}