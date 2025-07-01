import 'package:football_ticket/models/match_model.dart';
import 'package:football_ticket/models/stand_model.dart';


class MatchDetailsModel {
  // final String idTicket;
  final String idMatch;
  final MatchModel match;
  final List<StandModel> stand;

  MatchDetailsModel({
    // required this.idTicket,
    required this.idMatch,
    required this.match,
    required this.stand,
  });

  // factory MatchDetailsModel.fromJson(Map<String, dynamic> json) {
  //   return MatchDetailsModel(
  //     idTicket: json['idTicket'] as String,
  //     idMatch: json['idMatch'] as String,

  //     stand: StandModel.fromJson(json['stand'] as Map<String, dynamic>),
  //   );
  // }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'idTicket': idTicket,
  //     'idMatch': idMatch,
  //     'idTeamHome': idTeamHome,
  //     'idTeamAway': idTeamAway,
  //     'stand': stand.toJson(),
  //     'matchDate': matchDate,
  //     'teamHome': teamHome.toJson(),
  //     'teamAway': teamAway.toJson(),
  //   };
  // }
}
