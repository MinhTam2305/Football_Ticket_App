import 'package:equatable/equatable.dart';

abstract class BookingEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class BookTicketEvent extends BookingEvent {
  final int userId;
  final int matchId;
  final int standId;
  final int quantity;

  BookTicketEvent({
    required this.userId,
    required this.matchId,
    required this.standId,
    required this.quantity,
  });

  @override
  List<Object?> get props => [userId, matchId, standId, quantity];
}
