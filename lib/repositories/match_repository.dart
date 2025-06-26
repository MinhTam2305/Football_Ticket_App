import 'package:dio/dio.dart';
import 'package:football_ticket/models/match_model.dart';
import 'package:football_ticket/repositories/api_client.dart';

class MatchRepository {
  final Dio _dio = ApiClient.instance;
  Future<MatchModel> getMatchById(String id) async {
    try {
      final response =await _dio.get('Schedule/$id');
      if (response.statusCode == 200) {
        return MatchModel.fromJson(response.data);
      }
      else{
        throw "Error get match by id";
      }
    } catch (e) {
      throw "Error: $e";
    }
  }
}
