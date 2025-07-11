import 'package:equatable/equatable.dart';

abstract class TicketEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchMyTickets extends TicketEvent {
  final String userId;
  final String token;

  FetchMyTickets({required this.userId, required this.token});

  @override
  List<Object?> get props => [userId, token];
}
