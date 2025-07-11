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

        final used = data
            .where((booking) => booking.tickets.every((t) => t.ticketStatus == 'đã sử dụng'))
            .toList();

        final unused = data
            .where((booking) => booking.tickets.any((t) => t.ticketStatus != 'đã sử dụng'))
            .toList();

        emit(TicketLoaded(used: used, unused: unused));
      } catch (e) {
        emit(TicketError(message: e.toString()));
      }
    });
  }
}