class TicketInfoModel {
  final String ticketId;
  final String bookingId;
  final String standId;

  TicketInfoModel({
    required this.ticketId,
    required this.bookingId,
    required this.standId,
  });

  factory TicketInfoModel.fromJson(Map<String, dynamic> json) {
    return TicketInfoModel(
      ticketId: json['ticketId'],
      bookingId: json['bookingId'],
      standId: json['standId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ticketId': ticketId,
      'bookingId': bookingId,
      'standId': standId,
    };
  }
}
