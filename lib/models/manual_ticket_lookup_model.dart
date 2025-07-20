class ManualTicketLookupModel {
  final String ticketId;
  final String qrCode;
  final double price;
  final String issuedAt;
  final String currentStatus;
  final String statusChangedAt;
  final Stand stand;
  final Match match;

  ManualTicketLookupModel({
    required this.ticketId,
    required this.qrCode,
    required this.price,
    required this.issuedAt,
    required this.currentStatus,
    required this.statusChangedAt,
    required this.stand,
    required this.match,
  });

  factory ManualTicketLookupModel.fromJson(Map<String, dynamic> json) {
    return ManualTicketLookupModel(
      ticketId: json['ticketId'],
      qrCode: json['qrCode'],
      price: json['price'],
      issuedAt: json['issuedAt'],
      currentStatus: json['currentStatus'],
      statusChangedAt: json['statusChangedAt'],
      stand: Stand.fromJson(json['stand']),
      match: Match.fromJson(json['match']),
    );
  }
}

class Stand {
  final String standId;
  final String name;
  final int capacity;
  final int price;

  Stand({
    required this.standId,
    required this.name,
    required this.capacity,
    required this.price,
  });

  factory Stand.fromJson(Map<String, dynamic> json) {
    return Stand(
      standId: json['standId'],
      name: json['name'],
      capacity: (json['capacity'] as num).toInt(), // ✅ Sửa chỗ này
      price: (json['price'] as num).toInt(),       // ✅ Và chỗ này nếu lỗi
    );
  }
}

class Match {
  final String matchId;
  final String matchDateTime;
  final Team homeTeam;
  final Team awayTeam;

  Match({
    required this.matchId,
    required this.matchDateTime,
    required this.homeTeam,
    required this.awayTeam,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      matchId: json['matchId'],
      matchDateTime: json['matchDateTime'],
      homeTeam: Team.fromJson(json['homeTeam']),
      awayTeam: Team.fromJson(json['awayTeam']),
    );
  }
}

class Team {
  final String teamId;
  final String teamName;
  final String logo;

  Team({
    required this.teamId,
    required this.teamName,
    required this.logo,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      teamId: json['teamId'],
      teamName: json['teamName'],
      logo: json['logo'],
    );
  }
}