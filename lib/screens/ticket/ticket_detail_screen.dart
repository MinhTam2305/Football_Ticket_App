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
          'Ticket',
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
          children: [
            Text(
              booking.matchName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textMain,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: QrImageView(
                data: ticket.qrCode,
                version: QrVersions.auto,
                size: 220.0,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Status: ${ticket.ticketStatus}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMain,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 18, color: AppColors.textSub),
                      const SizedBox(width: 4),
                      Text(
                        _formatDateTime(booking.matchDateTime),
                        style: const TextStyle(color: AppColors.textSub),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 18, color: AppColors.textSub),
                      const SizedBox(width: 4),
                      const Text("Sân vận động Gò Đậu", style: TextStyle(color: AppColors.textSub)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Khán đài: ${ticket.standName}', style: const TextStyle(color: AppColors.textSub)),
                  Text('Giá vé: ${ticket.price} đ', style: const TextStyle(color: AppColors.textSub)),
                  Text('Ngày xuất vé: ${_formatDateTime(ticket.issuedAt)}',
                      style: const TextStyle(color: AppColors.textSub)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    return "${dt.day}/${dt.month}/${dt.year} - ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}";
  }
}