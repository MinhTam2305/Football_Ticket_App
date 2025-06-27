import 'package:dio/dio.dart';
import 'package:football_ticket/models/match_model.dart';
import 'package:football_ticket/repositories/api_client.dart';

class MatchRepository {
  final Dio _dio = ApiClient.instance;

  // Future<List<MatchModel>> getMatch() async {
  //   try {
  //     final response = await _dio.get('Schedule');
  //     if (response.statusCode == 200) {
  //       final List<dynamic> rawList = response.data;
  //       final now = DateTime.now();
  //       return rawList.map((json) => MatchModel.fromJson(json)).where((match) {
  //         final matchTime = match.matchDateTime;
  //         final difference = matchTime.difference(now).inDays;
  //         return matchTime.isAfter(now) && difference >= 2;
  //       }).toList();
  //     } else {
  //       throw Exception("Error get match by id");
  //     }
  //   } catch (e) {
  //     throw Exception("Error: $e");
  //   }
  // }

  Future<MatchModel> getMatchById(String id) async {
    try {
      final response = await _dio.get('Schedule/$id');
      if (response.statusCode == 200) {
        return MatchModel.fromJson(response.data);
      } else {
        throw Exception("Error get match by id");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  Future<List<MatchModel>> getMatch(String? idTeam) async {
    try {
      final response = await _dio.get('Schedule');
      if (response.statusCode == 200) {
        final List<dynamic> rawList = response.data;
        final now = DateTime.now();
        return rawList.map((json) => MatchModel.fromJson(json)).where((match) {
          final matchTime = match.matchDateTime;
          final difference = matchTime.difference(now).inDays;
          if(idTeam!=null)
          {
          final bool isGetMatchByTeam =
              (match.homeTeamId == idTeam || match.awayTeamId == idTeam);
          return matchTime.isAfter(now) && difference >= 2 && isGetMatchByTeam;
          }
           return matchTime.isAfter(now) && difference >= 2;
        }).toList();
      } else {
        throw Exception("Error get match by id");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}
