import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/manual_ticket_lookup_model.dart';

class ManualTicketLookupRepository {
  final String baseUrl;

  ManualTicketLookupRepository({required this.baseUrl});

  Future<ManualTicketLookupModel> lookupTicket(String code) async {
    final url = Uri.parse('$baseUrl/api/TicketApi/manual-lookup?code=$code');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      return ManualTicketLookupModel.fromJson(jsonData['data']);
    } else {
      throw Exception('Không thể tra cứu vé (Mã: ${response.statusCode})');
    }
  }
}