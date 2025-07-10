import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:football_ticket/models/payment_request_model.dart';
import 'package:football_ticket/models/payment_response_model.dart';

class PaymentRepository {
  final String baseUrl;

  PaymentRepository({required this.baseUrl});

  Future<PaymentResponseModel> createPayment(PaymentRequestModel request) async {
    print('Request body: ${jsonEncode(request.toJson())}');
    final response = await http.post(
      Uri.parse('$baseUrl/api/Payment/create-payment'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      print("json: ${request.toJson()}");
      return PaymentResponseModel.fromJson(json);
    } else {
      print('❌ Payment API Error: StatusCode=${response.statusCode}');
      print('❌ Response body: ${response.body}');
      throw Exception('Failed to create payment link');
    }
  }
}
