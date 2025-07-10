import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_ticket/blocs/booking/booking_bloc.dart';
import 'package:football_ticket/blocs/booking/booking_event.dart';
import 'package:football_ticket/blocs/booking/booking_state.dart';
import 'package:football_ticket/blocs/payment/payment_bloc.dart';
import 'package:football_ticket/blocs/payment/payment_event.dart';
import 'package:football_ticket/blocs/payment/payment_state.dart';
import 'package:football_ticket/core/constants/colors.dart';
import 'package:football_ticket/models/match_details_model.dart';
import 'package:football_ticket/models/stand_model.dart';
import 'package:football_ticket/models/user_model.dart';
// import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

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
  late StreamSubscription _sub;

  @override
  void initState() {
    super.initState();
    // _sub = uriLinkStream.listen((Uri? uri) {
    //   final result = uri?.queryParameters['result'];
    //   if (result == 'success') {
    //     // Gọi API booking
    //     context.read<BookingBloc>().add(
    //       BookTicketEvent(
    //         userId: widget.user.uid!,
    //         matchId: widget.detailsMatch.idMatch,
    //         standId: widget.stand.standId,
    //         quantity: widget.quantity,
    //       ),
    //     );
    //   } else if (result == 'fail') {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(content: Text('Payment failed')),
    //     );
    //   }
    // }, onError: (err) {
    //   print('Deep link error: $err');
    // });
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  void _startPayment() {
    context.read<PaymentBloc>().add(
      CreatePaymentEvent(
        orderId: 'ORDER123',
        orderInfo: 'Buy ${widget.quantity} ticket(s)',
        amount: widget.totlePrice.toDouble(),
        returnUrl: 'myapp://payment-result',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: const BackButton(color: AppColors.textMain),
        title: Text("Cart", style: AppTextStyles.title2),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // UI giữ nguyên như bạn cũ
            // ...
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Quantity:", style: AppTextStyles.body1),
                Text("${widget.quantity}", style: AppTextStyles.body1),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Price:", style: AppTextStyles.body1),
                Text("${widget.totlePrice.toStringAsFixed(0)}đ", style: AppTextStyles.body1),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: MultiBlocListener(
          listeners: [
            BlocListener<PaymentBloc, PaymentState>(
              listener: (context, state) async {
                if (state is PaymentLoading) return;
                if (state is PaymentSuccess) {
                  final url = state.paymentUrl;
                  if (await canLaunchUrl(Uri.parse(url))) {
                    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Could not open browser')),
                    );
                  }
                } else if (state is PaymentFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Payment Error: ${state.message}')),
                  );
                }
              },
            ),
            BlocListener<BookingBloc, BookingState>(
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
            ),
          ],
          child: BlocBuilder<PaymentBloc, PaymentState>(
            builder: (context, state) {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: state is PaymentLoading ? null : _startPayment,
                child: state is PaymentLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text("Payment", style: AppTextStyles.button.copyWith(color: Colors.white)),
              );
            },
          ),
        ),
      ),
    );
  }
}