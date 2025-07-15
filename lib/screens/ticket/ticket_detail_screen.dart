import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '/models/ticket_model.dart';
import '/models/booking_ticket_model.dart';
import '/core/constants/colors.dart';

class TicketDetailScreen extends StatelessWidget {
  final TicketModel ticket;
  final BookingTicket booking;

  const TicketDetailScreen({
    super.key,
    required this.ticket,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: const BackButton(color: AppColors.textMain),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'Ticket Detail',
          style: TextStyle(
            color: AppColors.textMain,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /// 🔹 Tên trận đấu
            Text(
              booking.matchName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textMain,
              ),
            ),
            const SizedBox(height: 20),

            /// 🔹 QR Code
            Center(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    )
                  ],
                ),
                child: QrImageView(
                  data: ticket.ticketId,
                  version: QrVersions.auto,
                  size: 200.0,
                ),
              ),
            ),
            const SizedBox(height: 20),

            /// 🔹 Thông tin vé
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListView(
                  children: [
                    _infoRow('Trạng thái', ticket.ticketStatus),
                    _infoRow('Ngày thi đấu', _formatDateTime(booking.matchDateTime)),
                    _infoRow('Khán đài', ticket.standName),
                    _infoRow('Giá vé', '${ticket.price.toStringAsFixed(0)} đ'),
                    _infoRow('Ngày xuất vé', _formatDateTime(ticket.issuedAt)),
                    _infoRow('Địa điểm', 'Sân vận động Gò Đậu'),
                    _infoRow('Mã vé', ticket.ticketId),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              "$label:",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textMain,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              style: const TextStyle(color: AppColors.textSub),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    return "${dt.day}/${dt.month}/${dt.year} - ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}";
  }
}