import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '/core/constants/colors.dart';
import '/models/ticket_model.dart';

class TicketCheckDetailScreen extends StatelessWidget {
  //final Ticket ticket;

  //const TicketCheckDetailScreen({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        leading: const BackButton(color: AppColors.textMain),
        title: const Text('Check ticket', style: TextStyle(color: AppColors.textMain)),
        actions: [
          IconButton(
            icon: const Icon(Icons.error_outline, color: AppColors.error),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              //child: QrImageView(
                //data: ticket.matchName + ticket.dateTime,
                //version: QrVersions.auto,
                //size: 200.0,
              ),
            //),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Text('Buyer: ${ticket.buyerName}',
                      //style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 18),
                      const SizedBox(width: 6),
                      //Text(ticket.dateTime),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 18),
                      const SizedBox(width: 6),
                      //Text(ticket.location),
                    ],
                  ),
                  const SizedBox(height: 8),
                  //Text('Quantity: ${ticket.quantity}'),
                  //Text('Stand: ${ticket.stand}'),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // TODO: xử lý khi bấm check vé (nếu cần)
                },
                child: const Text('Check',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}