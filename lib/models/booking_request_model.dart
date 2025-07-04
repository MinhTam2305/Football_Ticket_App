class BookingRequestModel {
  final int userId;
  final int matchId;
  final int standId;

  BookingRequestModel({
    required this.userId,
    required this.matchId,
    required this.standId,
  });

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "matchId": matchId,
      "standId": standId,
    };
  }
}