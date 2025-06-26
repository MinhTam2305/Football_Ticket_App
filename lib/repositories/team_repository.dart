import 'package:dio/dio.dart';
import 'package:football_ticket/models/team_model.dart';
import 'package:football_ticket/repositories/api_client.dart';

class TeamRepository {
  final Dio _dio = ApiClient.instance;
  Future<TeamModel> getTeamById(String id) async {
    

    try {
      final response = await _dio.get('Team/$id');
      if (response.statusCode == 200) {
        return TeamModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load team');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Something went wrong');
    }
  }
}
