class TeamModel {
  final String teamId;
  final String teamName;
  final String description;
  final String logo;

  TeamModel({
    required this.teamId,
    required this.teamName,
    required this.description,
    required this.logo,
  });

  factory TeamModel.fromJson(Map<String, dynamic> json) {
    return TeamModel(
      teamId: json['teamId'],
      teamName: json['teamName'],
      description: json['description'],
      logo: "https://localhost:7023${json['logo']}",
    );
  }
}
