import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '/models/ticket_model.dart';
import '/core/constants/colors.dart'; // Đảm bảo import file color.dart

class TicketDetailScreen extends StatelessWidget {
  final Ticket ticket;

  const TicketDetailScreen({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // ✅ màu nền toàn màn hình
      appBar: AppBar(
        leading: const BackButton(color: AppColors.textMain),
        centerTitle: true,
        backgroundColor: AppColors.background, // ✅ giống nền
        elevation: 0,
        title: const Text(
          'Ticket',
          style: TextStyle(color: AppColors.textMain, fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              ticket.matchName,
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
                color: AppColors.white, // ✅ ô QR màu trắng
                borderRadius: BorderRadius.circular(12),
              ),
              child: QrImageView(
                data: ticket.idTicket,
                version: QrVersions.auto,
                size: 220.0,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.white, // ✅ ô thông tin màu trắng
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Buyer: ${ticket.buyerName}',
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
                      Text(ticket.dateTime, style: const TextStyle(color: AppColors.textSub)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 18, color: AppColors.textSub),
                      const SizedBox(width: 4),
                      Text(ticket.location, style: const TextStyle(color: AppColors.textSub)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Quantity: ${ticket.quantity}', style: const TextStyle(color: AppColors.textSub)),
                  Text('Stand: ${ticket.stand}', style: const TextStyle(color: AppColors.textSub)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}