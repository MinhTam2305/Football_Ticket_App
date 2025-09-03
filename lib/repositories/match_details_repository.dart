import 'package:dio/dio.dart';
import 'package:football_ticket/models/accessory_model.dart';
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

        // Lấy match cơ bản
        final matchId = (data['matchId'] ?? idMatch).toString();
        final MatchModel match = await _matchRepo.getMatchById(matchId);

        // Stands
        final List standListJson = (data['stands'] ?? []) as List;
        final List<StandModel> standList =
            standListJson.map((e) => StandModel.fromJson(e)).toList();

        // Map image + Google Maps url
        final String? mapImageUrl =
            (data['mapImageUrl'] ?? data['map_image_url'])?.toString();
        final String? mapUrl = (data['mapUrl'] ?? data['map_url'])?.toString();

        // Accessories
        final List accListJson = (data['accessories'] ?? []) as List;
        final accessories =
            accListJson
                .map(
                  (e) => AccessoryModel.fromJson(Map<String, dynamic>.from(e)),
                )
                .toList();
        return MatchDetailsModel(
          idMatch: idMatch,
          match: match,
          stand: standList,
          mapImageUrl: mapImageUrl,
          mapUrl: mapUrl,
          accessories: accessories,
        );
      } else {
        throw Exception("Error get match details");
      }
    } catch (e) {
      throw Exception("Lỗi khi lấy danh sách trận đấu: $e");
    }
  }
}
