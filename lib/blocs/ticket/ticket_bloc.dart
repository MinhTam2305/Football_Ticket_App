import 'package:flutter_bloc/flutter_bloc.dart';
import '/models/booking_ticket_model.dart';
import '/repositories/ticket_repository.dart';
import 'ticket_event.dart';
import 'ticket_state.dart';

class TicketBloc extends Bloc<TicketEvent, TicketState> {
  final TicketRepository repository;

  TicketBloc({required this.repository}) : super(TicketInitial()) {
    on<FetchMyTickets>((event, emit) async {
      emit(TicketLoading());

      try {
        final data = await repository.fetchMyTickets(event.userId, event.token);
        final now = DateTime.now();

        final used = data
            .where((booking) => booking.matchDateTime.isBefore(now))
            .toList();

        final unused = data
            .where((booking) => booking.matchDateTime.isAfter(now))
            .toList();

        emit(TicketLoaded(used: used, unused: unused));
      } catch (e) {
        emit(TicketError(message: e.toString()));
      }
    });
  }
}