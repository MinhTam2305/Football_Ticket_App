import 'package:flutter_bloc/flutter_bloc.dart';
import 'payment_event.dart';
import 'payment_state.dart';
import '/repositories/payment_repository.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentRepository paymentRepository;

  PaymentBloc({required this.paymentRepository}) : super(PaymentInitial()) {
    on<PaymentRequested>((event, emit) async {
      emit(PaymentLoading());
      try {
        final url = await paymentRepository.createPayment(
          userId: event.userId,
          amount: event.amount,
          description: event.description,
        );
        emit(PaymentSuccess(url));
      } catch (e) {
        emit(PaymentFailure(e.toString()));
      }
    });
  }
}