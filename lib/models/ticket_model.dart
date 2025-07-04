class Ticket {
  final String idTicket;
  final String matchName;
  final String dateTime;
  final int quantity;
  final bool isUsed;
  final String buyerName;
  final String location;
  final String stand;

  Ticket({
    required this.idTicket,
    required this.matchName,
    required this.dateTime,
    required this.quantity,
    required this.isUsed,
    required this.buyerName,
    required this.location,
    required this.stand,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      idTicket: json['idTicket'],
      matchName: json['matchName'],
      dateTime: json['dateTime'],
      quantity: json['quantity'],
      isUsed: json['isUsed'],
      buyerName: json['buyerName'],
      location: json['location'],
      stand: json['stand'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idTicket': idTicket,
      'matchName': matchName,
      'dateTime': dateTime,
      'quantity': quantity,
      'isUsed': isUsed,
      'buyerName': buyerName,
      'location': location,
      'stand': stand,
    };
  }
}