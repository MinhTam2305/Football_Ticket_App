import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/manual_ticket_lookup/manual_ticket_lookup_bloc.dart';
import '../../blocs/manual_ticket_lookup/manual_ticket_lookup_event.dart';
import '../../blocs/manual_ticket_lookup/manual_ticket_lookup_state.dart';
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
      appBar: AppBar(title: const Text("Check ticket")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 32),
            const Icon(Icons.confirmation_number, size: 100, color: Colors.blue),
            const SizedBox(height: 24),
            TextField(
              controller: _codeController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.phone),
                hintText: "Enter your number",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _onCheck,
                child: const Text("Check ticket"),
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
                  return const CircularProgressIndicator();
                } else if (state is ManualTicketLookupFailure) {
                  return Text(state.message, style: const TextStyle(color: Colors.red));
                }
                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }
}