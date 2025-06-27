import 'package:football_ticket/models/team_model.dart';
import 'package:intl/intl.dart';

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
  String get matchDate =>
      DateFormat('dd/MM').format(matchDateTime.toLocal());
           String get matchDateMY =>
      DateFormat('dd/MM/yyyy').format(matchDateTime.toLocal());

  String get matchTime => DateFormat('HH:mm').format(matchDateTime.toLocal());
}
