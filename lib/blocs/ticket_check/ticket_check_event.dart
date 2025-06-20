abstract class TicketCheckEvent {}

class CheckTicketByPhone extends TicketCheckEvent {
  final String phoneNumber;

  CheckTicketByPhone(this.phoneNumber);
}
