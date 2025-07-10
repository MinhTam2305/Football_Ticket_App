import '/models/ticket_model.dart';

class TicketRepository {
  static Future<List<Ticket>> getTicketsByPhone(String phone) async {
    await Future.delayed(const Duration(seconds: 1));

    if (phone == '12345') {
      return [
        Ticket(
          idTicket: 'f661e11a-82bf-4439-8c0c-64677ecf5248',
          matchName: 'Viet Nam vs Malaysia',
          dateTime: 'CN, 8 Th6, 2025 - 8:00',
          location: 'Go Dau',
          quantity: 1,
          isUsed: false,
          stand: 'A',
          buyerName: 'Ho Minh Tam',
        ),
        Ticket(
          idTicket: '026936e1-264f-4555-8413-489ad4202440',
          matchName: 'Viet Nam vs Brazil',
          dateTime: 'CN, 22 Th6, 2025 - 17:00',
          location: 'Go Dau',
          quantity: 1,
          isUsed: false,
          stand: 'A',
          buyerName: 'Ho Minh Tam',
        ),
        Ticket(
          idTicket: '026936e1-264f-4555-8413-489ad4202440',
          matchName: 'Viet Nam vs Indonesia',
          dateTime: 'Th5, 26 Th6, 2025 - 18:00',
          location: 'Go Dau',
          quantity: 2,
          isUsed: false,
          stand: 'A',
          buyerName: 'Ho Minh Tam',
        ),
      ];
    } else {
      return [];
    }
  }
}
