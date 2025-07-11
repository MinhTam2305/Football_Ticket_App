import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/core/constants/colors.dart';
import '/blocs/ticket_check/ticket_check_bloc.dart';
import '/blocs/ticket_check/ticket_check_event.dart';
import '/blocs/ticket_check/ticket_check_state.dart';
import 'manual_check_result_screen.dart'; // màn hình kết quả

class ManualCheckTicketScreen extends StatefulWidget {
  const ManualCheckTicketScreen({super.key});

  @override
  State<ManualCheckTicketScreen> createState() => _ManualCheckTicketScreenState();
}

class _ManualCheckTicketScreenState extends State<ManualCheckTicketScreen> {
  final TextEditingController phoneController = TextEditingController();

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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Icon(Icons.confirmation_number, size: 80, color: AppColors.primary),
                  const SizedBox(height: 24),
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.white,
                      hintText: 'Enter your phone number',
                      prefixIcon: const Icon(Icons.phone),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.primary),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.primary, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
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
                  final phone = phoneController.text.trim();
                  if (phone.isNotEmpty) {
                    //context.read<TicketCheckBloc>().add(CheckTicketByPhone(phone));
                  }
                },
                child: const Text(
                  'Check ticket',
                  style: TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            /// BlocBuilder xử lý trạng thái
            //BlocBuilder<TicketCheckBloc, TicketCheckState>(
            //  builder: (context, state) {
            //    if (state is TicketCheckLoading) {
            //      return const CircularProgressIndicator();
            //    } else if (state is TicketCheckFailure) {
            //      return Text(
            //        state.error,
            //        style: const TextStyle(color: AppColors.error),
            //      );
            //    } else if (state is TicketCheckSuccess) {
            //      WidgetsBinding.instance.addPostFrameCallback((_) {
            //        Navigator.push(
            //          context,
            //          MaterialPageRoute(
            //            builder: (_) => ManualCheckResultScreen(
            //              name: state.name,
            //             phone: phoneController.text.trim(),
            //              tickets: state.tickets,
            //            ),
            //          ),
            //        );
            //      });
            //      return const SizedBox(); // tránh lỗi build lại nhiều lần
            //    }
            //    return const SizedBox();
            //  },
          //  ),
          ],
        ),
      ),
    );
  }
}