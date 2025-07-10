import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_ticket/blocs/booking_details/booking_details_event.dart';
import 'package:football_ticket/blocs/booking_details/booking_details_state.dart';
import 'package:football_ticket/repositories/booking_details_repository.dart';

class BookingDetailsBloc
    extends Bloc<BookingDetailsEvent, BookingDetailsState> {
  BookingDetailsRepository bookingDetailRepo;
  BookingDetailsBloc(this.bookingDetailRepo)
    : super(BookingDetailsInitialState()) {
    on<LoadBookingDetailsEvent>(_onLoadBookingDetails);
  }

  Future<void> _onLoadBookingDetails(
    LoadBookingDetailsEvent event,
    Emitter<BookingDetailsState> emit,
  ) async {
    emit(BookingDetailsLoadingState());
    try {
      final bookingDetails = await bookingDetailRepo.scanQr(
        event.ticketId,
        event.token,
      );
      emit(BookingDetailsLoadedState(bookingDetails: bookingDetails));
    } catch (e) {
      emit(BookingDetailsErrorState(error: e.toString()));
    }
  }
}
