import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_ticket/blocs/booking/booking_bloc.dart';
import 'package:football_ticket/blocs/booking/booking_event.dart';
import 'package:football_ticket/blocs/payment/payment_bloc.dart';
import 'package:football_ticket/blocs/payment/payment_event.dart';
import 'package:football_ticket/blocs/payment/payment_state.dart';
import 'package:football_ticket/core/constants/colors.dart';
import 'package:football_ticket/models/match_details_model.dart';
import 'package:football_ticket/models/stand_model.dart';
import 'package:football_ticket/models/user_model.dart';
import 'package:football_ticket/screens/payment/webview_payment_screen.dart';

class CartScreen extends StatefulWidget {
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
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: const BackButton(color: AppColors.textMain),
        centerTitle: true,
        title: const Text(
          "Cart",
          style: TextStyle(
            color: AppColors.textMain,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Image.network(widget.detailsMatch.match.homeTeam.logo, width: 50, height: 40),
                                const SizedBox(height: 5),
                                Text(widget.detailsMatch.match.homeTeam.teamName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                              ],
                            ),
                            const Text("VS", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            Column(
                              children: [
                                Image.network(widget.detailsMatch.match.awayTeam.logo, width: 50, height: 40),
                                const SizedBox(height: 5),
                                Text(widget.detailsMatch.match.awayTeam.teamName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _infoRow(Icons.access_time, widget.detailsMatch.match.matchTime),
                        const SizedBox(height: 6),
                        _infoRow(Icons.location_on_outlined, "Go Dau"),
                        const SizedBox(height: 6),
                        _plainText("Stand: ${widget.stand.standName}"),
                        const SizedBox(height: 4),
                        _plainText("Remaining Tickets: ${widget.stand.availabelTickets}"),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset("assets/images/stadium.png", fit: BoxFit.cover),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _infoRowPlain("Quantity:", widget.quantity.toString()),
                  const SizedBox(height: 8),
                  _infoRowPlain("Price:", "${widget.totlePrice.toStringAsFixed(0)}đ"),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: _buildPaymentButton(context),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textSub),
        const SizedBox(width: 8),
        Text(value, style: const TextStyle(color: AppColors.textSub, fontSize: 14)),
      ],
    );
  }

  Widget _plainText(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(text, style: const TextStyle(color: AppColors.textSub, fontSize: 14)),
    );
  }

  Widget _infoRowPlain(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textMain, fontSize: 16)),
        Text(value, style: const TextStyle(color: AppColors.textMain, fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildPaymentButton(BuildContext context) {
    return BlocConsumer<PaymentBloc, PaymentState>(
      listener: (context, state) async {
        if (state is PaymentSuccess) {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => WebViewPaymentScreen(paymentUrl: state.paymentUrl),
            ),
          );

          if (result == true) {
            context.read<BookingBloc>().add(
              BookTicketEvent(
                userId: widget.user.uid!,
                matchId: widget.detailsMatch.idMatch,
                standId: widget.stand.standId,
                quantity: widget.quantity,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Thanh toán thất bại!")),
            );
          }
        } else if (state is PaymentFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Payment failed: ${state.message}")),
          );
        }
      },
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: state is PaymentLoading
                ? null
                : () {
              context.read<PaymentBloc>().add(
                CreatePaymentEvent(
                  orderId: '${DateTime.now().millisecondsSinceEpoch}',
                  orderInfo: 'ThanhToanVe',
                  amount: widget.totlePrice.toStringAsFixed(0),
                  returnUrl: 'https://intership.hqsolutions.vn/api/Payment/onepay-return',
                ),
              );
            },
            child: state is PaymentLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text("Payment", style: AppTextStyles.button.copyWith(color: Colors.white)),
          ),
        );
      },
    );
  }
}