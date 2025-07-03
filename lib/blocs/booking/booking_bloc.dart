import 'package:flutter_bloc/flutter_bloc.dart';
import 'booking_event.dart';
import 'booking_state.dart';
import '../../repositories/booking_repository.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingRepository repository;

  BookingBloc(this.repository) : super(BookingInitial()) {
    on<BookingRequested>((event, emit) async {
      emit(BookingLoading());
      try {
        await repository.bookTicket(
          userId: event.userId,
          matchId: event.matchId,
          quantity: event.quantity,
          stand: event.stand,
        );
        emit(BookingSuccess());
      } catch (e) {
        emit(BookingFailure(e.toString()));
      }
    });
  }
}