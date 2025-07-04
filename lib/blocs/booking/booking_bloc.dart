import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_ticket/repositories/booking_repository.dart';
import 'package:football_ticket/models/booking_request_model.dart';
import 'booking_event.dart';
import 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingRepository bookingRepository;

  BookingBloc({required this.bookingRepository}) : super(BookingInitial()) {
    on<BookTicketEvent>((event, emit) async {
      emit(BookingLoading());
      try {
        final request = BookingRequestModel(
          userId: event.userId,
          matchId: event.matchId,
          standId: event.standId,
        );
        await bookingRepository.createBooking(request);
        emit(BookingSuccess());
      } catch (e) {
        emit(BookingFailure(message: e.toString()));
      }
    });
  }
}
