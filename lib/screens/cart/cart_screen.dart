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
<<<<<<< HEAD
// import 'package:uni_links/uni_links.dart';
=======
import 'package:football_ticket/blocs/payment/payment_bloc.dart';
import 'package:football_ticket/blocs/payment/payment_event.dart';
import 'package:football_ticket/blocs/payment/payment_state.dart';
>>>>>>> 7e934a2758adf64294dc24ea11ce0dc981769d2b
import 'package:url_launcher/url_launcher.dart';
import 'package:football_ticket/screens/payment/payment_result_handler.dart';

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
<<<<<<< HEAD
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
=======
>>>>>>> 7e934a2758adf64294dc24ea11ce0dc981769d2b
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
        child: BlocConsumer<PaymentBloc, PaymentState>(
          listener: (context, state) async {
            if (state is PaymentSuccess) {
              final Uri paymentUrl = Uri.parse(state.paymentUrl);
              String paymentstring = paymentUrl.toString();
              ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text(paymentstring)));
              if (await canLaunchUrl(paymentUrl)) {
                await launchUrl(
                    paymentUrl, mode: LaunchMode.inAppBrowserView);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        PaymentResultHandler(
                          detailsMatch: detailsMatch,
                          stand: stand,
                          quantity: quantity,
                          user: user,
                        ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not open payment URL')));
              }
            } else if (state is PaymentFailure) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Payment failed: ${state.message}")));
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
              onPressed: state is PaymentLoading
                  ? null
                  : () {
                context.read<PaymentBloc>().add(
                  CreatePaymentEvent(
                    orderId: 'ORDER_${DateTime.now().millisecondsSinceEpoch}', // Hoặc mã đơn hàng của bạn
                    orderInfo: 'Thanh toán vé cho trận ${detailsMatch.match.homeTeam.teamName} vs ${detailsMatch.match.awayTeam.teamName}',
                    amount: totlePrice,
                    returnUrl: 'https://intership.hqsolutions.vn/api/Payment/onepay-return', // URL backend xử lý kết quả thanh toán
                  ),
                );
              },
              child: state is PaymentLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text("Payment", style: AppTextStyles.button.copyWith(color: Colors.white)),
            );
          },
        ),
      ),
    );
  }
}