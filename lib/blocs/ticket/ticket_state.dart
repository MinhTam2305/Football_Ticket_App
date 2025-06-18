import '/models/ticket_model.dart';

abstract class TicketState {}

class TicketInitial extends TicketState {}

class TicketLoaded extends TicketState {
  final List<Ticket> tickets;

  TicketLoaded(this.tickets);
}