class NewsMatchDetailModel {
  final String matchId;
  final String homeTeamName;
  final String awayTeamName;
  final String homeTeamLogo;
  final String awayTeamLogo;
  final int homeScore;
  final int awayScore;
  final String matchDateTime;
  final List<GoalModel> homeTeamGoals;
  final List<GoalModel> awayTeamGoals;

  NewsMatchDetailModel({
    required this.matchId,
    required this.homeTeamName,
    required this.awayTeamName,
    required this.homeTeamLogo,
    required this.awayTeamLogo,
    required this.homeScore,
    required this.awayScore,
    required this.matchDateTime,
    required this.homeTeamGoals,
    required this.awayTeamGoals,
  });

  factory NewsMatchDetailModel.fromJson(Map<String, dynamic> json) {
    return NewsMatchDetailModel(
      matchId: json['matchId'],
      homeTeamName: json['homeTeamName'],
      awayTeamName: json['awayTeamName'],
      homeTeamLogo: json['homeTeamLogo'],
      awayTeamLogo: json['awayTeamLogo'],
      homeScore: json['homeScore'],
      awayScore: json['awayScore'],
      matchDateTime: json['matchDateTime'],
      homeTeamGoals: (json['homeTeamGoals'] as List)
          .map((e) => GoalModel.fromJson(e))
          .toList(),
      awayTeamGoals: (json['awayTeamGoals'] as List)
          .map((e) => GoalModel.fromJson(e))
          .toList(),
    );
  }
}

class GoalModel {
  final String playerName;
  final String goalTime;

  GoalModel({required this.playerName, required this.goalTime});

  factory GoalModel.fromJson(Map<String, dynamic> json) {
    return GoalModel(
      playerName: json['playerName'],
      goalTime: json['goalTime'],
    );
  }
}