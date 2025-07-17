import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_match_model.dart';

class NewsMatchRepository {
  final String baseUrl;

  NewsMatchRepository({required this.baseUrl});

  Future<List<NewsMatchModel>> fetchNewsMatches() async {
    final response = await http.get(Uri.parse('$baseUrl/api/GoalOfTheMatchApi'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List matches = data['data'];
      return matches.map((e) => NewsMatchModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load news_match matches');
    }
  }
}