import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/manual_ticket_lookup/manual_ticket_lookup_bloc.dart';
import '../../blocs/manual_ticket_lookup/manual_ticket_lookup_event.dart';
import '../../blocs/manual_ticket_lookup/manual_ticket_lookup_state.dart';
import '../../core/constants/colors.dart';
import 'manual_ticket_detail_screen.dart';

class ManualTicketLookupScreen extends StatefulWidget {
  const ManualTicketLookupScreen({super.key});

  @override
  State<ManualTicketLookupScreen> createState() => _ManualTicketLookupScreenState();
}

class _ManualTicketLookupScreenState extends State<ManualTicketLookupScreen> {
  final TextEditingController _codeController = TextEditingController();

  void _onCheck() {
    final code = _codeController.text.trim();
    if (code.isNotEmpty) {
      context.read<ManualTicketLookupBloc>().add(LookupTicketEvent(code));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          "Check ticket",
          style: TextStyle(
            color: AppColors.textMain,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.confirmation_number, size: 100, color: AppColors.primary),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _codeController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.phone),
                        hintText: "Enter code ticket",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: AppColors.background,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _onCheck,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Check ticket",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white, // ✅ In đậm và trắng
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              BlocConsumer<ManualTicketLookupBloc, ManualTicketLookupState>(
                listener: (context, state) {
                  if (state is ManualTicketLookupSuccess) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ManualTicketDetailScreen(ticket: state.ticket),
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is ManualTicketLookupLoading) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is ManualTicketLookupFailure) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(state.message, style: AppTextStyles.error),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}