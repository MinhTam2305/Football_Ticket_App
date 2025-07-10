class TicketModel {
  final String ticketId;
  final String standName;
  final int price;
  final String qrCode;
  final DateTime issuedAt;
  final String ticketStatus;
  final DateTime statusChangedAt;

  TicketModel({
    required this.ticketId,
    required this.standName,
    required this.price,
    required this.qrCode,
    required this.issuedAt,
    required this.ticketStatus,
    required this.statusChangedAt,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    return TicketModel(
      ticketId: json['ticketId'],
      standName: json['standName'],
      price: json['price'],
      qrCode: json['qrCode'] ?? '',
      issuedAt: DateTime.parse(json['issuedAt']),
      ticketStatus: json['ticketStatus'],
      statusChangedAt: DateTime.parse(json['statusChangedAt']),
    );
  }
}