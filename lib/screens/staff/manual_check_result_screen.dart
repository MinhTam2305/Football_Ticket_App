import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '/core/constants/colors.dart';
import '/models/ticket_model.dart';
import 'ticket_check_detail_screen.dart'; // 👈 Thêm import

class ManualCheckResultScreen extends StatelessWidget {
  final String name;
  final String phone;
  //final List<Ticket> tickets;

  const ManualCheckResultScreen({
    super.key,
    required this.name,
    required this.phone,
    //required this.tickets,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: const Text('Check ticket', style: TextStyle(color: AppColors.textMain)),
        leading: const BackButton(color: AppColors.textMain),
        actions: [
          IconButton(
            icon: const Icon(Icons.error_outline, color: AppColors.error),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.primary.withOpacity(0.2)),
          ),
          child: Column(
            children: [
              const Icon(Icons.account_circle, size: 64, color: AppColors.textMain),
              const SizedBox(height: 8),
              Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(phone, style: const TextStyle(color: AppColors.textSub)),
              const SizedBox(height: 16),

              /// Danh sách vé có thể click
              //...tickets.map((ticket) => _buildTicketItem(context, ticket)).toList(),
            ],
          ),
        ),
      ),
    );
  }

  //Widget _buildTicketItem(BuildContext context, Ticket ticket) {
  //  return GestureDetector(
  //    onTap: () {
  //      Navigator.push(
  //        context,
  //        MaterialPageRoute(
  //          builder: (_) => TicketCheckDetailScreen(ticket: ticket),
  //        ),
  //      );
  //    },
  //    child: Container(
  //      margin: const EdgeInsets.only(bottom: 12),
  //      padding: const EdgeInsets.all(8),
  //      decoration: BoxDecoration(
  //        border: Border.all(color: AppColors.primary.withOpacity(0.4)),
  //        borderRadius: BorderRadius.circular(12),
  //      ),
  //      child: Row(
  //        children: [
  //          QrImageView(
  //            data: ticket.matchName + ticket.dateTime,
  //            version: QrVersions.auto,
  //            size: 60.0,
  //          ),
  //          const SizedBox(width: 8),
  //          Expanded(
  //            child: Column(
  //              crossAxisAlignment: CrossAxisAlignment.start,
  //              children: [
  //                Text(ticket.matchName, style: const TextStyle(fontWeight: FontWeight.bold)),
  //                Text(ticket.dateTime, style: const TextStyle(color: AppColors.textSub)),
  //                Text('Số lượng vé: ${ticket.quantity}', style: const TextStyle(color: AppColors.textSub)),
  //              ],
  //            ),
  //          ),
  //        ],
  //      ),
  //    ),
  //  );
  //}
}