class Ticket {
  final String matchName;
  final String dateTime;
  final int quantity;
  final bool isUsed; // vé đã dùng hay chưa

  Ticket({
    required this.matchName,
    required this.dateTime,
    required this.quantity,
    required this.isUsed,
  });
}