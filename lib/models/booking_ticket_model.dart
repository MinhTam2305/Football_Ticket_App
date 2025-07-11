import 'ticket_model.dart';

class BookingTicket {
  final String bookingId;
  final String userId;
  final String matchId;
  final String matchName;
  final DateTime matchDateTime;
  final DateTime bookingTime;
  final String bookingStatus;
  final List<TicketModel> tickets;
  final double totalAmount;

  BookingTicket({
    required this.bookingId,
    required this.userId,
    required this.matchId,
    required this.matchName,
    required this.matchDateTime,
    required this.bookingTime,
    required this.bookingStatus,
    required this.tickets,
    required this.totalAmount,
  });

  factory BookingTicket.fromJson(Map<String, dynamic> json) {
    return BookingTicket(
      bookingId: json['bookingId'],
      userId: json['userId'],
      matchId: json['matchId'],
      matchName: json['matchName'],
      matchDateTime: DateTime.parse(json['matchDateTime']),
      bookingTime: DateTime.parse(json['bookingTime']),
      bookingStatus: json['bookingStatus'],
      tickets: (json['tickets'] as List)
          .map((e) => TicketModel.fromJson(e))
          .toList(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
    );
  }
}