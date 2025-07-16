import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_model.dart';

class NewsRepository {
  Future<List<NewsItem>> fetchNews() async {
    final url = Uri.parse('https://intership.hqsolutions.vn/api/NewsApi?page=1&pageSize=20');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List items = data['items'];
      return items.map((e) => NewsItem.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load news");
    }
  }
}