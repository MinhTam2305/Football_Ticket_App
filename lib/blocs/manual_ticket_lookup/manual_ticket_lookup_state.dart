import 'package:equatable/equatable.dart';
import '../../models/manual_ticket_lookup_model.dart';

abstract class ManualTicketLookupState extends Equatable {
  const ManualTicketLookupState();

  @override
  List<Object?> get props => [];
}

class ManualTicketLookupInitial extends ManualTicketLookupState {}

class ManualTicketLookupLoading extends ManualTicketLookupState {}

class ManualTicketLookupSuccess extends ManualTicketLookupState {
  final ManualTicketLookupModel ticket;

  const ManualTicketLookupSuccess(this.ticket);

  @override
  List<Object?> get props => [ticket];
}

class ManualTicketLookupFailure extends ManualTicketLookupState {
  final String message;

  const ManualTicketLookupFailure(this.message);

  @override
  List<Object?> get props => [message];
}