import 'package:equatable/equatable.dart';

class BookingDetailsEvent extends Equatable{
  const BookingDetailsEvent();

  @override
  List<Object?> get props => [];
}

class LoadBookingDetailsEvent extends BookingDetailsEvent {
  final String bookingId;
  final String token;

  const LoadBookingDetailsEvent({
    required this.bookingId,
    required this.token,
  });

  @override
  List<Object?> get props => [bookingId, token];
}