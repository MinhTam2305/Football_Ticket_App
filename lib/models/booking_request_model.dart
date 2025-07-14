class BookingRequestModel {
  final String userId;
  final String matchId;
  final String standId;
  final int quantity;

  BookingRequestModel({
    required this.userId,
    required this.matchId,
    required this.standId,
    required this.quantity,
  });

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'matchId': matchId,
    'standId': standId,
    'quantity': quantity,
  };
}