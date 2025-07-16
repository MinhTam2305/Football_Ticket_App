class NewsMatchModel {
  final String matchId;
  final String matchDate;
  final String homeTeamName;
  final String awayTeamName;
  final String homeTeamLogo;
  final String awayTeamLogo;
  final int homeScore;
  final int awayScore;

  NewsMatchModel({
    required this.matchId,
    required this.matchDate,
    required this.homeTeamName,
    required this.awayTeamName,
    required this.homeTeamLogo,
    required this.awayTeamLogo,
    required this.homeScore,
    required this.awayScore,
  });

  factory NewsMatchModel.fromJson(Map<String, dynamic> json) {
    return NewsMatchModel(
      matchId: json['matchId'],
      matchDate: json['matchDate'],
      homeTeamName: json['homeTeamName'],
      awayTeamName: json['awayTeamName'],
      homeTeamLogo: json['homeTeamLogo'],
      awayTeamLogo: json['awayTeamLogo'],
      homeScore: json['homeScore'],
      awayScore: json['awayScore'],
    );
  }
}