part of 'booking_bloc.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object> get props => [];
}

class BookingRequested extends BookingEvent {
  final String userId;
  final String matchId;
  final int quantity;
  final String stand;

  const BookingRequested({
    required this.userId,
    required this.matchId,
    required this.quantity,
    required this.stand,
  });

  @override
  List<Object> get props => [userId, matchId, quantity, stand];
}