import 'dart:convert';
import 'package:http/http.dart' as http;
import '/models/news_match_detail_model.dart';

class NewsMatchDetailRepository {
  final String baseUrl = 'https://intership.hqsolutions.vn';

  Future<NewsMatchDetailModel> fetchNewsMatchDetail(String matchId) async {
    final url = Uri.parse('$baseUrl/api/GoalOfTheMatchApi/$matchId');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonBody = json.decode(response.body);
      final data = jsonBody['data'];
      return NewsMatchDetailModel.fromJson(data);
    } else {
      throw Exception('Failed to load news_match match detail');
    }
  }
}