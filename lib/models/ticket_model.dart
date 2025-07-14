class TicketModel {
  final String ticketId;
  final String standName;
  final double price;
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
      ticketId: json['ticketId'] ?? '',
      standName: json['standName'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      qrCode: json['qrCode'] ?? '',
      issuedAt: json['issuedAt'] != null
          ? DateTime.parse(json['issuedAt'])
          : DateTime.now(),
      ticketStatus: json['ticketStatus'] ?? '',
      statusChangedAt: json['statusChangedAt'] != null
          ? DateTime.parse(json['statusChangedAt'])
          : DateTime.now(),
    );
  }
}