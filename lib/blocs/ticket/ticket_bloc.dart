import 'package:flutter_bloc/flutter_bloc.dart';
import '/models/ticket_model.dart';
import '/blocs/ticket/ticket_event.dart';
import '/blocs/ticket/ticket_state.dart';

class TicketBloc extends Bloc<TicketEvent, TicketState> {
  TicketBloc() : super(TicketInitial()) {
    on<LoadTickets>((event, emit) async {
      // Simulate loading tickets
      await Future.delayed(const Duration(seconds: 1));

      List<Ticket> tickets = [
        Ticket(
          matchName: "Viet Nam vs Malaysia",
          dateTime: "CN, 8 Th6, 2025 - 8:00",
          quantity: 1,
          isUsed: false,
          buyerName: "Ho Minh Tam",
          location: "Go Dau",
          stand: "A",
        ),
        Ticket(
          matchName: "Viet Nam vs Brazil",
          dateTime: "CN, 22 Th6, 2025 - 17:00",
          quantity: 1,
          isUsed: false,
          buyerName: "Ho Minh Tam",
          location: "Go Dau",
          stand: "A",
        ),
        Ticket(
          matchName: "Viet Nam vs Indonesia",
          dateTime: "Th5, 26 Th6, 2025 - 18:00",
          quantity: 2,
          isUsed: false,
          buyerName: "Ho Minh Tam",
          location: "Go Dau",
          stand: "A",
        ),
        Ticket(
          matchName: "Viet Nam vs India",
          dateTime: "Th7, 3 Th5, 2025 - 18:00",
          quantity: 1,
          isUsed: true,
          buyerName: "Ho Minh Tam",
          location: "Go Dau",
          stand: "A",
        ),
        Ticket(
          matchName: "Viet Nam vs Singapore",
          dateTime: "CN, 11 Th5, 2025 - 18:00",
          quantity: 2,
          isUsed: true,
          buyerName: "Ho Minh Tam",
          location: "Go Dau",
          stand: "A",
        ),
      ];

      emit(TicketLoaded(tickets));
    });
  }
}