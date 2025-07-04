class BookingRequestModel {
  final String userId;
  final String matchId;
  final String standId;

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