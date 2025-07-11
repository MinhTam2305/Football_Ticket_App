import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/booking_ticket_model.dart';

class TicketRepository {
  final String baseUrl;

  TicketRepository({required this.baseUrl});

  Future<List<BookingTicket>> fetchMyTickets(String userId, String token) async {
    final url = Uri.parse('$baseUrl/api/BookingApi/user/ticket/$userId');

    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final List<dynamic> data = body['data'];

      return data.map((e) => BookingTicket.fromJson(e)).toList();
    } else {
      throw Exception('Lỗi lấy danh sách vé: ${response.body}');
    }
  }
}