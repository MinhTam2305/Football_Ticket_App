import 'package:flutter_bloc/flutter_bloc.dart';
import '/models/booking_ticket_model.dart';
import '/repositories/ticket_repository.dart';
import 'ticket_event.dart';
import 'ticket_state.dart';

class TicketBloc extends Bloc<TicketEvent, TicketState> {
  final TicketRepository repository;

<<<<<<< HEAD
      List<Ticket> tickets = [
        Ticket(
          idTicket: '97013c6a-ada2-4dc0-9932-8068842d44ab',
          matchName: "Viet Nam vs Malaysia",
          dateTime: "CN, 8 Th6, 2025 - 8:00",
          quantity: 1,
          isUsed: false,
          buyerName: "Ho Minh Tam",
          location: "Go Dau",
          stand: "A",
        ),
        Ticket(
           idTicket: '072c15f0-1e26-4cea-9e33-a17d5f5ad74e',
          matchName: "Viet Nam vs Brazil",
          dateTime: "CN, 22 Th6, 2025 - 17:00",
          quantity: 1,
          isUsed: false,
          buyerName: "Ho Minh Tam",
          location: "Go Dau",
          stand: "A",
        ),
        Ticket(
           idTicket: '026936e1-264f-4555-8413-489ad4202440',
          matchName: "Viet Nam vs Indonesia",
          dateTime: "Th5, 26 Th6, 2025 - 18:00",
          quantity: 2,
          isUsed: false,
          buyerName: "Ho Minh Tam",
          location: "Go Dau",
          stand: "A",
        ),
        Ticket(
          idTicket: '026936e1-264f-4555-8413-489ad4202440',
          matchName: "Viet Nam vs India",
          dateTime: "Th7, 3 Th5, 2025 - 18:00",
          quantity: 1,
          isUsed: true,
          buyerName: "Ho Minh Tam",
          location: "Go Dau",
          stand: "A",
        ),
        Ticket(
           idTicket: '026936e1-264f-4555-8413-489ad4202440',
          matchName: "Viet Nam vs Singapore",
          dateTime: "CN, 11 Th5, 2025 - 18:00",
          quantity: 2,
          isUsed: true,
          buyerName: "Ho Minh Tam",
          location: "Go Dau",
          stand: "A",
        ),
      ];
=======
  TicketBloc({required this.repository}) : super(TicketInitial()) {
    on<FetchMyTickets>((event, emit) async {
      emit(TicketLoading());
>>>>>>> c85ab9ad5f48df6d20250d3b4379e10d12767ac4

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