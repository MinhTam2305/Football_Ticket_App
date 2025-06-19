import 'package:equatable/equatable.dart';
import '/models/ticket_model.dart';

abstract class TicketState extends Equatable {
  const TicketState();

  @override
  List<Object> get props => [];
}

class TicketInitial extends TicketState {}

class TicketLoaded extends TicketState {
  final List<Ticket> tickets;

  const TicketLoaded(this.tickets);

  @override
  List<Object> get props => [tickets];
}