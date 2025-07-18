import 'package:equatable/equatable.dart';

abstract class ManualTicketLookupEvent extends Equatable {
  const ManualTicketLookupEvent();

  @override
  List<Object> get props => [];
}

class LookupTicketEvent extends ManualTicketLookupEvent {
  final String code;

  const LookupTicketEvent(this.code);

  @override
  List<Object> get props => [code];
}