class StandModel {
  final String standId;
  final String standName;
  final double price;
  final int totalTickets;
  final int availabelTickets;
  final int soldTickets;
  final String formattedPrice;
  final double availabitityPercentage;

  StandModel({
    required this.standId,
    required this.standName,
    required this.price,
    required this.totalTickets,
    required this.availabelTickets,
    required this.soldTickets,
    required this.formattedPrice,
    required this.availabitityPercentage,
  });
  factory StandModel.fromJson(Map<String, dynamic> json) {
    return StandModel(
      standId: json['standId'] as String,
      standName: json['standName'] as String,
      price: (json['price'] as num).toDouble(),
      totalTickets: json['totalTickets'] as int,
      availabelTickets: json['availableTickets'] as int,
      soldTickets: json['soldTickets'] as int,
      formattedPrice: json['formattedPrice'] as String,
      availabitityPercentage:
          (json['availabilityPercentage'] as num).toDouble(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'standId': standId,
      'standName': standName,
      'price': price,
      'totalTickets': totalTickets,
      'availabelTickets': availabelTickets,
      'soldTickets': soldTickets,
      'formattedPrice': formattedPrice,
      'availabitityPercentage': availabitityPercentage,
    };
  }
}
