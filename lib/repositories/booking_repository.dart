import 'package:http/http.dart' as http;
import 'dart:convert';

class BookingRepository {
  final String baseUrl;

  BookingRepository({required this.baseUrl});

  Future<void> bookTicket({
    required String userId,
    required String matchId,
    required int quantity,
    required String stand,
  }) async {
    final url = Uri.parse('$baseUrl/api/BookingApi');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'userId': userId,
        'matchId': matchId,
        'quantity': quantity,
        'stand': stand,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Đặt vé thất bại: ${response.body}');
    }
  }
}