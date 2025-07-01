import 'package:dio/dio.dart';
import 'package:football_ticket/models/match_details_model.dart';
import 'package:football_ticket/models/match_model.dart';
import 'package:football_ticket/models/stand_model.dart';
import 'package:football_ticket/repositories/api_client.dart';
import 'package:football_ticket/repositories/match_repository.dart';

class MatchDetailsRepository {
  final Dio _dio = ApiClient.instance;
  final MatchRepository _matchRepo = MatchRepository();

  Future<MatchDetailsModel> getMatch(String token, String idMatch) async {
    try {
      final response = await _dio.get(
        'TicketApi/match/$idMatch/details',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        final data = response.data['data'];
        final matchId = data['matchId'];
        MatchModel match = await _matchRepo.getMatchById(matchId);
        final List<dynamic> standListJson = data['stands'];

        final List<StandModel> standList =
            standListJson
                .map((standJson) => StandModel.fromJson(standJson))
                .toList();
        MatchDetailsModel matchDetails = MatchDetailsModel(
          idMatch: idMatch,
          match: match,
          stand: standList,
        );

        return matchDetails;
      } else {
        throw Exception("Error get match details");
      }
    } catch (e) {
      throw Exception("Lỗi khi lấy danh sách trận đấu: $e");
    }
  }
}
