import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '/screens/cart/cart_successful_screen.dart';
import '/blocs/payment/payment_bloc.dart';
import '/blocs/payment/payment_event.dart';
import '/blocs/payment/payment_state.dart';
import '/blocs/booking/booking_bloc.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<BookingBloc, BookingState>(
          listener: (context, state) {
            if (state is BookingSuccess) {
              // Sau khi đặt vé thành công → gọi thanh toán
              context.read<PaymentBloc>().add(
                PaymentRequested(
                  userId: 'a80314a7-7150-4413-803e-4c91ce6d8513',
                  amount: 500000,
                  description: 'Thanh toán vé Việt Nam vs Malaysia',
                ),
              );
            } else if (state is BookingFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Đặt vé thất bại: ${state.error}')),
              );
            }
          },
        ),
        BlocListener<PaymentBloc, PaymentState>(
          listener: (context, state) async {
            if (state is PaymentSuccess) {
              final Uri paymentUri = Uri.parse(state.paymentUrl);
              if (await canLaunchUrl(paymentUri)) {
                await launchUrl(paymentUri, mode: LaunchMode.externalApplication);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Không thể mở link thanh toán')),
                );
              }
            } else if (state is PaymentFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Thanh toán thất bại: ${state.error}')),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          leading: const BackButton(),
          centerTitle: true,
          title: const Text(
            'Cart',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // [Giao diện hiển thị trận đấu y như bạn đã có]
              // ...

              const SizedBox(height: 16),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Quantity:', style: TextStyle(fontSize: 16)),
                  Text('1', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 8),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Price:', style: TextStyle(fontSize: 16)),
                  Text('500.000đ',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    // Gọi đặt vé trước
                    context.read<BookingBloc>().add(
                      const BookingRequested(
                        userId: 'a80314a7-7150-4413-803e-4c91ce6d8513',
                        matchId: '62d45aee-7e3c-4d83-8e23-61e361662255',
                        quantity: 1,
                        stand: 'A',
                      ),
                    );
                  },
                  child: const Text(
                    'Thanh Toán',
                    style: TextStyle(fontSize: 16, color: Colors.white),
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