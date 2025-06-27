import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '/blocs/ticket/ticket_bloc.dart';
import '/blocs/ticket/ticket_event.dart';
import '/blocs/ticket/ticket_state.dart';
import '/models/ticket_model.dart';
import '/screens/ticket/ticket_detail_screen.dart';
import '/core/constants/colors.dart';

class TicketScreen extends StatefulWidget {
  const TicketScreen({super.key});

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<TicketBloc>().add(LoadTickets());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Ticket'),
        backgroundColor: AppColors.background,
        titleTextStyle: new TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textMain),

      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          _buildTab(),
          const SizedBox(height: 16),
          Expanded(
            child: BlocBuilder<TicketBloc, TicketState>(
              builder: (context, state) {
                if (state is TicketLoaded) {
                  List<Ticket> tickets = state.tickets;

                  List<Ticket> filteredTickets = tickets.where((ticket) {
                    return selectedIndex == 0 ? !ticket.isUsed : ticket.isUsed;
                  }).toList();

                  return ListView.builder(
                    itemCount: filteredTickets.length,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemBuilder: (context, index) {
                      return _buildTicketItem(filteredTickets[index]);
                    },
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary), // ✅
      ),
      child: Row(
        children: [
          _buildTabButton('Unused', 0),
          _buildTabButton('Used', 1),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, int index) {
    bool isSelected = selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.secondary : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? AppColors.textMain : AppColors.textMain,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTicketItem(Ticket ticket) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TicketDetailScreen(ticket: ticket),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white, // ✅ nền item
          border: Border.all(color: AppColors.primary),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            QrImageView(
              data: ticket.matchName + ticket.dateTime,
              version: QrVersions.auto,
              size: 80.0,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ticket.matchName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.textMain,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(ticket.dateTime, style: const TextStyle(color: AppColors.textSub)),
                  const SizedBox(height: 4),
                  Text('Số lượng vé: ${ticket.quantity}', style: const TextStyle(color: AppColors.textSub)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}