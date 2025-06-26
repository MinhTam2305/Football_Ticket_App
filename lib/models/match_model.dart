import 'package:football_ticket/models/team_model.dart';

class MatchModel {
  final String matchId;
  final String homeTeamId;
  final String awayTeamId;
  final DateTime matchDateTime;
  final TeamModel homeTeam;
  final TeamModel awayTeam;
  MatchModel({
    required this.matchId,
    required this.homeTeamId,
    required this.awayTeamId,
    required this.matchDateTime,
    required this.homeTeam,
    required this.awayTeam,
  });
  factory MatchModel.fromJson(Map<String, dynamic> json) {
    return MatchModel(
      matchId: json['matchId'],
      homeTeamId: json['homeTeamId'],
      awayTeamId: json['awayTeamId'],
      matchDateTime: DateTime.parse(json['matchDateTime']),
      homeTeam: TeamModel.fromJson(json['homeTeam']),
      awayTeam: TeamModel.fromJson(json['awayTeam']),
    );
  }

  @override
  String toString() {
    return 'MatchModel(matchId: $matchId, homeTeamId: $homeTeamId, awayTeamId: $awayTeamId, matchDateTime: $matchDateTime, homeTeam: $homeTeam, awayTeam: $awayTeam)';
  }
}
