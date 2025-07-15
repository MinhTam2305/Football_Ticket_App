import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:football_ticket/models/booking_request_model.dart';

class BookingRepository {
  final String baseUrl = 'https://intership.hqsolutions.vn/api/BookingApi';

  Future<void> createBooking(BookingRequestModel request, String token) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token", // ✅ Thêm token vào đây
      },
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to book ticket: ${response.body}');
    }
  }
}
