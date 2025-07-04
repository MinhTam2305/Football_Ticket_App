import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_ticket/blocs/booking/booking_bloc.dart';
import 'package:football_ticket/blocs/booking/booking_event.dart';
import 'package:football_ticket/blocs/booking/booking_state.dart';
import 'package:football_ticket/core/constants/colors.dart';
import 'package:football_ticket/models/match_details_model.dart';
import 'package:football_ticket/models/stand_model.dart';
import 'package:football_ticket/models/ticket_detail_model.dart';
import 'package:football_ticket/models/user_model.dart';

class CartScreen extends StatelessWidget {
  final MatchDetailsModel detailsMatch;
   final UserModel user;
   final StandModel stand;
  final double totlePrice;
 final int quantity;
  

  const CartScreen({
    super.key,
    required this.detailsMatch,
    required this.user,
    required this.stand,
    required this.totlePrice,
    required this.quantity,

  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: BackButton(color: AppColors.textMain),
        title: Text("Cart", style: AppTextStyles.title2),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: AppColors.primary),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Image.network(detailsMatch.match.homeTeam.logo, width: 60, height: 40),
                            const SizedBox(height: 5),
                            Text(detailsMatch.match.homeTeam.teamName, style: AppTextStyles.body1),
                          ],
                        ),
                        Text("VS", style: AppTextStyles.title1),
                        Column(
                          children: [
                            Image.network(detailsMatch.match.awayTeam.logo, width: 60, height: 40),
                            const SizedBox(height: 5),
                            Text(detailsMatch.match.awayTeam.teamName, style: AppTextStyles.body1),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.date_range_outlined, size: 20, color: AppColors.grey),
                        const SizedBox(width: 8),
                        Text(detailsMatch.match.matchTime, style: AppTextStyles.body2),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 20, color: AppColors.grey),
                        const SizedBox(width: 8),
                        Text("Go Dau", style: AppTextStyles.body2),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text("Stand: ${stand.standName}", style: AppTextStyles.body2),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text("Remaining Tickets: ${stand.availabelTickets}", style: AppTextStyles.body2),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset("assets/images/stadium.png", height: 130, fit: BoxFit.cover),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Quantity:", style: AppTextStyles.body1),
                Text("${quantity}", style: AppTextStyles.body1),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Price:", style: AppTextStyles.body1),
                Text("${totlePrice.toStringAsFixed(0)}đ", style: AppTextStyles.body1),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocConsumer<BookingBloc, BookingState>(
          listener: (context, state) {
            if (state is BookingSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Booking successful!")),
              );
              Navigator.pop(context);
            } else if (state is BookingFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Booking failed: ${state.message}")),
              );
            }
          },
          builder: (context, state) {
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: state is BookingLoading
                  ? null
                  : () {
                context.read<BookingBloc>().add(
                  BookTicketEvent(
                    userId: user.uid!,
                    matchId: detailsMatch.idMatch,
                    standId: stand.standId,
                    quantity: quantity,
                  ),
                );
              },
              child: state is BookingLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text("Payment", style: AppTextStyles.button.copyWith(color: Colors.white)),
            );
          },
        ),
      ),
    );
  }
}