import 'package:http/http.dart' as http;
import 'dart:convert';
import '/models/booking_model.dart'; // ✅ Import model BookingRequest

class BookingRepository {
  final String baseUrl;

  BookingRepository({required this.baseUrl});

  Future<void> bookTicket(BookingRequest request) async {
    final url = Uri.parse('$baseUrl/api/BookingApi');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(request.toJson()), // ✅ Sử dụng model để convert
    );

    if (response.statusCode != 200) {
      throw Exception('Đặt vé thất bại: ${response.body}');
    }
  }
}