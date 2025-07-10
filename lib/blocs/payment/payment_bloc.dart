import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_ticket/blocs/payment/payment_event.dart';
import 'package:football_ticket/blocs/payment/payment_state.dart';
import 'package:football_ticket/models/payment_request_model.dart';
import 'package:football_ticket/repositories/payment_repository.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentRepository paymentRepository;

  PaymentBloc({required this.paymentRepository}) : super(PaymentInitial()) {
    on<CreatePaymentEvent>(_onCreatePayment);
  }

  Future<void> _onCreatePayment(
      CreatePaymentEvent event,
      Emitter<PaymentState> emit,
      ) async {
    emit(PaymentLoading());
    try {
      final request = PaymentRequestModel(
        orderId: event.orderId,
        orderInfo: event.orderInfo,
        amount: event.amount.toInt(),
        returnUrl: event.returnUrl,
      );

      final response = await paymentRepository.createPayment(request);
      emit(PaymentSuccess(response.paymentUrl));
    } catch (e) {
      emit(PaymentFailure(e.toString()));
    }
  }
}