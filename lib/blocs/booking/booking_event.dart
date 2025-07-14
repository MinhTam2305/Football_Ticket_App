import 'package:equatable/equatable.dart';

abstract class BookingEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class BookTicketEvent extends BookingEvent {
  final String userId;
  final String matchId;
  final String standId;
  final int quantity;
  final String token;

  BookTicketEvent({
    required this.userId,
    required this.matchId,
    required this.standId,
    required this.quantity,
    required this.token,
  });

  @override
  List<Object?> get props => [userId, matchId, standId, quantity, token];
}
