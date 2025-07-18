import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '/blocs/ticket/ticket_bloc.dart';
import '/blocs/ticket/ticket_event.dart';
import '/blocs/ticket/ticket_state.dart';
import '/models/booking_ticket_model.dart';
import '/models/ticket_model.dart';
import '/core/constants/colors.dart';
import '/screens/ticket/ticket_detail_screen.dart';

class TicketScreen extends StatefulWidget {
  final String userId;
  final String token;

  const TicketScreen({
    super.key,
    required this.userId,
    required this.token,
  });

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<TicketBloc>().add(
      FetchMyTickets(
        userId: widget.userId,
        token: widget.token,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Ticket'),
        backgroundColor: AppColors.background,
        titleTextStyle: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.textMain,
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          _buildTab(),
          const SizedBox(height: 16),
          Expanded(
            child: BlocBuilder<TicketBloc, TicketState>(
              builder: (context, state) {
                if (state is TicketLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is TicketLoaded) {
                  final List<BookingTicket> bookingList =
                  selectedIndex == 0 ? state.unused : state.used;

                  // ⚠️ Chỉ hiển thị các ticket có ticketStatus phù hợp với tab
                  final ticketItems = bookingList.expand((booking) {
                    final filteredTickets = booking.tickets.where((ticket) {
                      final status = ticket.ticketStatus.toLowerCase();
                      if (selectedIndex == 0) {
                        return status == 'đã phát hành';
                      } else {
                        return status == 'đã ra sân';
                      }
                    }).map((ticket) => {
                      "booking": booking,
                      "ticket": ticket,
                    });

                    return filteredTickets;
                  }).toList();

                  if (ticketItems.isEmpty) {
                    return const Center(child: Text("Không có vé nào."));
                  }

                  return ListView.builder(
                    itemCount: ticketItems.length,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemBuilder: (context, index) {
                      final booking =
                      ticketItems[index]["booking"] as BookingTicket;
                      final ticket =
                      ticketItems[index]["ticket"] as TicketModel;

                      return InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TicketDetailScreen(
                                ticket: ticket,
                                booking: booking,
                              ),
                            ),
                          );
                        },
                        child: _buildTicketItem(ticket, booking),
                      );
                    },
                  );
                } else if (state is TicketError) {
                  return Center(child: Text('Lỗi: ${state.message}'));
                } else {
                  return const Center(child: Text("Không có dữ liệu."));
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
        border: Border.all(color: AppColors.primary),
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
    final bool isSelected = selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.secondary : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.textMain,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTicketItem(TicketModel ticket, BookingTicket booking) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.primary),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          QrImageView(
            data: ticket.ticketId,
            version: QrVersions.auto,
            size: 80.0,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.matchName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.textMain,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDateTime(booking.matchDateTime),
                  style: const TextStyle(color: AppColors.textSub),
                ),
                const SizedBox(height: 4),
                Text(
                  'Khán đài: ${ticket.standName}',
                  style: const TextStyle(color: AppColors.textSub),
                ),
                const SizedBox(height: 4),
                Text(
                  'Giá vé: ${ticket.price.toStringAsFixed(0)} đ',
                  style: const TextStyle(color: AppColors.textSub),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    return "${dt.day}/${dt.month}/${dt.year} - "
        "${dt.hour}:${dt.minute.toString().padLeft(2, '0')}";
  }
}