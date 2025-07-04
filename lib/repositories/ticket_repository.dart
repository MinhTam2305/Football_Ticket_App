import '/models/ticket_model.dart';

class TicketRepository {
  static Future<List<Ticket>> getTicketsByPhone(String phone) async {
    await Future.delayed(const Duration(seconds: 1));

    if (phone == '12345') {
      return [
        Ticket(
          idTicket: '40442892-6d73-461b-9bd2-4b2c483054d0',
          matchName: 'Viet Nam vs Malaysia',
          dateTime: 'CN, 8 Th6, 2025 - 8:00',
          location: 'Go Dau',
          quantity: 1,
          isUsed: false,
          stand: 'A',
          buyerName: 'Ho Minh Tam',
        ),
        Ticket(
          idTicket: '829b9686-ef90-4f6b-bf53-366f1a54edf4',
          matchName: 'Viet Nam vs Brazil',
          dateTime: 'CN, 22 Th6, 2025 - 17:00',
          location: 'Go Dau',
          quantity: 1,
          isUsed: false,
          stand: 'A',
          buyerName: 'Ho Minh Tam',
        ),
        Ticket(
          idTicket: '201b0425-7ed3-4ce5-a3d4-6b06567d7f25',
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
