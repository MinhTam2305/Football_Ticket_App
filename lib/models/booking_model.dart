class BookingRequest {
  final String matchId;
  final String userId;
  final int quantity;
  final String stand;

  BookingRequest({
    required this.matchId,
    required this.userId,
    required this.quantity,
    required this.stand,
  });

  Map<String, dynamic> toJson() {
    return {
      'matchId': matchId,
      'userId': userId,
      'quantity': quantity,
      'stand': stand,
    };
  }
}
