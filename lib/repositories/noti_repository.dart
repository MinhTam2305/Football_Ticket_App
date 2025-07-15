import 'package:dio/dio.dart';
import 'package:football_ticket/models/notice_model.dart';
import 'package:football_ticket/repositories/api_client.dart';

class NotiRepository {
  final _dio = ApiClient.instance;
  Future<List<NoticeModel>> getNotices() async {
    try {
      final response = await _dio.get('newsApi');
      if (response.statusCode == 200) {
        List<dynamic> data = response.data['items'];
        return data.map((item) => NoticeModel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load notices: ${response.statusCode}');
      }
    } catch (e) {
         print(e.toString());
      throw Exception('Failed to load notices: $e');
    }
  }
}
