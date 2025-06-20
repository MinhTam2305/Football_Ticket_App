import '/models/ticket_model.dart';

abstract class TicketCheckState {}

class TicketCheckInitial extends TicketCheckState {}

class TicketCheckLoading extends TicketCheckState {}

class TicketCheckSuccess extends TicketCheckState {
  final String name;
  final List<Ticket> tickets;

  TicketCheckSuccess({required this.name, required this.tickets});
}

class TicketCheckFailure extends TicketCheckState {
  final String error;

  TicketCheckFailure(this.error);
}