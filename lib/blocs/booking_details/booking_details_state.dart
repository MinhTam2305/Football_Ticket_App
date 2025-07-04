import 'package:equatable/equatable.dart';
import 'package:football_ticket/models/detail_booking_model.dart';

class BookingDetailsState extends Equatable {
  const BookingDetailsState();

  @override
  List<Object?> get props => [];
}

class BookingDetailsInitialState extends BookingDetailsState {}

class BookingDetailsLoadingState extends BookingDetailsState {}

class BookingDetailsLoadedState extends BookingDetailsState {
  final DetailBookingModel bookingDetails;

  const BookingDetailsLoadedState({required this.bookingDetails});

  @override
  List<Object?> get props => [bookingDetails];
}

class BookingDetailsErrorState extends BookingDetailsState {
  final String error;

  const BookingDetailsErrorState({required this.error});

  @override
  List<Object?> get props => [error];
}
