class TicketModel {
  final String homeTeamName;
  final String awayTeamName;
  final String homeTeamLogo;
  final String awayTeamLogo;
  final String matchDateTime;
  final String stadium;
  final String standName;
  final int remainingTickets;
  final int quantity;
  final double price;

  TicketModel({
    required this.homeTeamName,
    required this.awayTeamName,
    required this.homeTeamLogo,
    required this.awayTeamLogo,
    required this.matchDateTime,
    required this.stadium,
    required this.standName,
    required this.remainingTickets,
    required this.quantity,
    required this.price,
  });
}
