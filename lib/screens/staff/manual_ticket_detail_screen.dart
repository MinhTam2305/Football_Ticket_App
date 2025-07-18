import 'package:flutter/material.dart';
import '../../models/manual_ticket_lookup_model.dart';

class ManualTicketDetailScreen extends StatelessWidget {
  final ManualTicketLookupModel ticket;

  const ManualTicketDetailScreen({super.key, required this.ticket});

  String formatDateTime(String dateTime) {
    final dt = DateTime.parse(dateTime);
    return "${dt.day}/${dt.month}/${dt.year} - ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final match = ticket.match;
    final home = match.homeTeam;
    final away = match.awayTeam;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chi tiết vé"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(home.logo, width: 60, height: 60),
                const SizedBox(width: 12),
                const Text("VS", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(width: 12),
                Image.network(away.logo, width: 60, height: 60),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              "${home.teamName} vs ${away.teamName}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text("Thời gian: ${formatDateTime(match.matchDateTime)}"),
            const SizedBox(height: 16),
            Divider(color: Colors.grey[300]),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.confirmation_number),
                const SizedBox(width: 8),
                Text("Số lượng: 1 vé"),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.event_seat),
                const SizedBox(width: 8),
                Text("Khán đài: ${ticket.stand.name}"),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.check_circle_outline),
                const SizedBox(width: 8),
                Text("Trạng thái: ${ticket.currentStatus}"),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.qr_code_2),
                const SizedBox(width: 8),
                Text("Mã vé: ${ticket.qrCode}"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}