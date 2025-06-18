import 'package:flutter_bloc/flutter_bloc.dart';
import '/models/ticket_model.dart';
import 'ticket_event.dart';
import 'ticket_state.dart';

class TicketBloc extends Bloc<TicketEvent, TicketState> {
  TicketBloc() : super(TicketInitial()) {
    on<LoadTickets>((event, emit) {
      List<Ticket> tickets = [
        Ticket(
          matchName: "Viet Nam vs Malaysia",
          dateTime: "CN, 8 Th6, 2025 - 8:00",
          quantity: 1,
        ),
        Ticket(
          matchName: "Viet Nam vs Brazil",
          dateTime: "CN, 22 Th6, 2025 - 17:00",
          quantity: 1,
        ),
        Ticket(
          matchName: "Viet Nam vs Indonesia",
          dateTime: "Th5, 26 Th6, 2025 - 18:00",
          quantity: 2,
        ),
      ];
      emit(TicketLoaded(tickets));
    });
  }
}