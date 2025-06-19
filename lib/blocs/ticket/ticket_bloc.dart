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
          isUsed: false,
          ticketCode: "VN-MY-20250608-0001", // mã vé
        ),
        Ticket(
          matchName: "Viet Nam vs Brazil",
          dateTime: "CN, 22 Th6, 2025 - 17:00",
          quantity: 1,
          isUsed: false,
          ticketCode: "VN-BR-20250622-0002",
        ),
        Ticket(
          matchName: "Viet Nam vs Indonesia",
          dateTime: "Th5, 26 Th6, 2025 - 18:00",
          quantity: 2,
          isUsed: false,
          ticketCode: "VN-ID-20250626-0003",
        ),
      ];
      emit(TicketLoaded(tickets));
    });
  }
}