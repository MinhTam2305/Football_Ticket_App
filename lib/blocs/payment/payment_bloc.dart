import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_ticket/blocs/payment/payment_event.dart';
import 'package:football_ticket/blocs/payment/payment_state.dart';
import 'package:football_ticket/models/payment_request_model.dart';
import 'package:football_ticket/models/booking_request_model.dart';
import 'package:football_ticket/repositories/payment_repository.dart';
import 'package:football_ticket/repositories/booking_repository.dart';
import 'package:football_ticket/blocs/ticket/ticket_bloc.dart';
import 'package:football_ticket/blocs/ticket/ticket_event.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentRepository paymentRepository;
  final BookingRepository bookingRepository;
  final TicketBloc ticketBloc;

  PaymentBloc({
    required this.paymentRepository,
    required this.bookingRepository,
    required this.ticketBloc,
  }) : super(PaymentInitial()) {
    on<CreatePaymentEvent>(_onCreatePayment);
    on<CompleteBookingAndRefreshTicketsEvent>(_onCompleteBookingAndRefreshTickets);
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
        amount: event.amount,
        returnUrl: event.returnUrl,
      );

      final response = await paymentRepository.createPayment(request);
      final paymentUrl = response.paymentUrl;


      emit(PaymentSuccess(response.paymentUrl));
    } catch (e) {
      emit(PaymentFailure(e.toString()));
    }
  }

  Future<void> _onCompleteBookingAndRefreshTickets(
      CompleteBookingAndRefreshTicketsEvent event,
      Emitter<PaymentState> emit,
      ) async {
    emit(PaymentLoading());
    try {
      final bookingRequest = BookingRequestModel(
        userId: event.userId,
        matchId: event.matchId,
        standId: event.standId,
        quantity: event.quantity, // ⚠️ quantity phải truyền vào đúng theo API yêu cầu
      );
      
      print(event.quantity);

      await bookingRepository.createBooking(bookingRequest, event.token);

      // Gọi lại TicketBloc để fetch danh sách vé mới
      ticketBloc.add(FetchMyTickets(userId: event.userId, token: event.token));

      emit(PaymentBookingComplete());
    } catch (e) {
      emit(PaymentFailure('Đặt vé thất bại: $e'));
    }
  }
}