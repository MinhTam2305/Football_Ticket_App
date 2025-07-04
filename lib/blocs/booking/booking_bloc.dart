import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '/models/booking_model.dart'; // ✅ BookingRequest model
import '/repositories/booking_repository.dart';

part 'booking_event.dart';
part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingRepository bookingRepository;

  BookingBloc(this.bookingRepository) : super(BookingInitial()) {
    on<BookingRequested>(_onBookingRequested);
  }

  Future<void> _onBookingRequested(
      BookingRequested event,
      Emitter<BookingState> emit,
      ) async {
    emit(BookingLoading());

    try {
      final bookingRequest = BookingRequest(
        userId: event.userId,
        matchId: event.matchId,
        quantity: event.quantity,
        stand: event.stand,
      );

      await bookingRepository.bookTicket(bookingRequest);
      emit(BookingSuccess());
    } catch (e) {
      emit(BookingFailure(error: e.toString()));
    }
  }
}