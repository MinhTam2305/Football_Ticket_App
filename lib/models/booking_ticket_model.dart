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
        bookingId: json['bookingId'] ?? '',
        userId: json['userId'] ?? '',
        matchId: json['matchId'] ?? '',
        matchName: json['matchName'] ?? '',
        matchDateTime: json['matchDateTime'] != null
            ? DateTime.parse(json['matchDateTime'])
            : DateTime.now(),
        bookingTime: json['bookingTime'] != null
            ? DateTime.parse(json['bookingTime'])
            : DateTime.now(),
        bookingStatus: json['bookingStatus'] ?? '',
        tickets: (json['tickets'] as List<dynamic>?)
            ?.map((e) => TicketModel.fromJson(e))
            .toList() ??
            [],
        totalAmount: json['totalAmount'] != null
            ? (json['totalAmount'] as num).toDouble()
            : 0.0,
      );
    }

    BookingTicket copyWith({List<TicketModel>? tickets}) {
      return BookingTicket(
        bookingId: bookingId,
        userId: userId,
        matchId: matchId,
        matchName: matchName,
        matchDateTime: matchDateTime,
        bookingTime: bookingTime,
        bookingStatus: bookingStatus,
        tickets: tickets ?? this.tickets,
        totalAmount: totalAmount,
      );
    }
  }
