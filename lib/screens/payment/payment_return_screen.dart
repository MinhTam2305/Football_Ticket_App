import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/blocs/payment/payment_bloc.dart';
import '/screens/tabs/ticket_screen.dart';
import '/blocs/payment/payment_event.dart';

class PaymentReturnScreen extends StatefulWidget {
  final String userId;
  final String matchId;
  final String standId;
  final String token;
  final int quantity;

  const PaymentReturnScreen({
    super.key,
    required this.userId,
    required this.matchId,
    required this.standId,
    required this.token,
    required this.quantity,
  });

  @override
  State<PaymentReturnScreen> createState() => _PaymentReturnScreenState();
}

class _PaymentReturnScreenState extends State<PaymentReturnScreen> {
  bool _isProcessing = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _handleBooking();
  }

  Future<void> _handleBooking() async {
    try {
      final paymentBloc = context.read<PaymentBloc>();

      paymentBloc.add(
        CompleteBookingAndRefreshTicketsEvent(
          userId: widget.userId,
          matchId: widget.matchId,
          standId: widget.standId,
          token: widget.token,
          quantity: widget.quantity,
        ),
      );

      // ✅ Delay để TicketBloc có thời gian fetch lại vé
      await Future.delayed(const Duration(seconds: 3));

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => TicketScreen(
            userId: widget.userId,
            token: widget.token,
          ),
        ),
            (route) => false,
      );
    } catch (e) {
      setState(() {
        _isProcessing = false;
        _error = 'Đặt vé thất bại: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isProcessing
            ? const CircularProgressIndicator()
            : _error != null
            ? Text(_error!, style: const TextStyle(color: Colors.red))
            : const Text('Xử lý thành công!'),
      ),
    );
  }
}