import 'package:equatable/equatable.dart';
import '/models/booking_ticket_model.dart';

abstract class TicketState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TicketInitial extends TicketState {}

class TicketLoading extends TicketState {}

class TicketLoaded extends TicketState {
  final List<BookingTicket> used;
  final List<BookingTicket> unused;

  TicketLoaded({required this.used, required this.unused});

  @override
  List<Object?> get props => [used, unused];
}

class TicketError extends TicketState {
  final String message;

  TicketError({required this.message});

  @override
  List<Object?> get props => [message];
}