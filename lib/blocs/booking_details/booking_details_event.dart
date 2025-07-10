import 'package:equatable/equatable.dart';

class BookingDetailsEvent extends Equatable{
  const BookingDetailsEvent();

  @override
  List<Object?> get props => [];
}

class LoadBookingDetailsEvent extends BookingDetailsEvent {
  final String ticketId;
  final String token;

  const LoadBookingDetailsEvent({
    required this.ticketId,
    required this.token,
  });

  @override
  List<Object?> get props => [ticketId, token];
}