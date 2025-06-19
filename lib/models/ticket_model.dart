class Ticket {
  final String matchName;
  final String dateTime;
  final int quantity;
  final bool isUsed;
  final String buyerName;
  final String location;
  final String stand;

  Ticket({
    required this.matchName,
    required this.dateTime,
    required this.quantity,
    required this.isUsed,
    required this.buyerName,
    required this.location,
    required this.stand,
  });
}