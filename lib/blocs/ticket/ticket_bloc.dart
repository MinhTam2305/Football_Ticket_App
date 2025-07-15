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

        final used = <BookingTicket>[];
        final unused = <BookingTicket>[];

        for (var booking in data) {
          final usedTickets = booking.tickets.where((t) => t.ticketStatus == 'Đã sử dụng' || t.ticketStatus == 'Đã vào sân' || t.ticketStatus == 'Đã ra sân').toList();
          final unusedTickets = booking.tickets.where((t) => t.ticketStatus == 'Đã phát hành').toList();

          if (usedTickets.isNotEmpty) {
            used.add(booking.copyWith(tickets: usedTickets));
          }
          if (unusedTickets.isNotEmpty) {
            unused.add(booking.copyWith(tickets: unusedTickets));
          }
        }

        emit(TicketLoaded(used: used, unused: unused));
      } catch (e) {
        emit(TicketError(message: e.toString()));
      }
    });
  }
}