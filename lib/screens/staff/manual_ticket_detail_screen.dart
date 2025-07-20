import 'package:flutter/material.dart';
import '../../models/manual_ticket_lookup_model.dart';
import '../../core/constants/colors.dart';

class ManualTicketDetailScreen extends StatelessWidget {
  final ManualTicketLookupModel ticket;

  const ManualTicketDetailScreen({super.key, required this.ticket});

  String formatDateTime(String dateTime) {
    final dt = DateTime.parse(dateTime);
    return "${dt.weekday == 7 ? "CN" : "T${dt.weekday}"}, ${dt.day} Th${dt.month}, ${dt.year} - ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}";
  }

  String fullLogoUrl(String logoPath) {
    const String host = 'https://intership.hqsolutions.vn';
    if (logoPath.startsWith('http')) return logoPath;
    return '$host$logoPath';
  }

  @override
  Widget build(BuildContext context) {
    final match = ticket.match;
    final home = match.homeTeam;
    final away = match.awayTeam;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        automaticallyImplyLeading: false, // ❌ Không có mũi tên AppBar
        title: const Align(
          alignment: Alignment.centerLeft, // ✅ Căn trái
          child: Text(
            "Check ticket",
            style: TextStyle(
              color: AppColors.textMain,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🔙 Mũi tên nằm trong khung
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back, color: AppColors.textMain),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(fullLogoUrl(home.logo), width: 60, height: 60),
                        const SizedBox(width: 12),
                        const Text("VS", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 12),
                        Image.network(fullLogoUrl(away.logo), width: 60, height: 60),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(home.teamName, style: AppTextStyles.body1),
                        Text(away.teamName, style: AppTextStyles.body1),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text("Time:", style: AppTextStyles.body2),
                    Text(formatDateTime(match.matchDateTime)),
                    const SizedBox(height: 12),
                    Text("Quantity:", style: AppTextStyles.body2),
                    const Text("1"),
                    const SizedBox(height: 12),
                    Text("Stand:", style: AppTextStyles.body2),
                    Text(ticket.stand.name),
                    const SizedBox(height: 12),
                    Text("Status:", style: AppTextStyles.body2),
                    Text(ticket.currentStatus),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: thêm chức năng nếu cần
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Check",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}