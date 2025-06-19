class Ticket {
  final String matchName;
  final String dateTime;
  final int quantity;
  final bool isUsed;
  final String ticketCode; // <-- thêm field này

  Ticket({
    required this.matchName,
    required this.dateTime,
    required this.quantity,
    required this.isUsed,
    required this.ticketCode, // <-- thêm required
  });
}