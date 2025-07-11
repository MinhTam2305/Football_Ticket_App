import 'package:flutter_bloc/flutter_bloc.dart';
import 'ticket_check_event.dart';
import 'ticket_check_state.dart';
import '/models/ticket_model.dart';
import '/repositories/ticket_repository.dart'; // cần tạo tiếp file này

//class TicketCheckBloc extends Bloc<TicketCheckEvent, TicketCheckState> {
  //TicketCheckBloc() : super(TicketCheckInitial()) {
    //on<CheckTicketByPhone>(_onCheckTicketByPhone);
  //}

  Future<void> _onCheckTicketByPhone(
      CheckTicketByPhone event,
      Emitter<TicketCheckState> emit,
      ) async {
    emit(TicketCheckLoading());

    //try {
      //final tickets = await TicketRepository.getTicketsByPhone(event.phoneNumber);

      const buyerName = 'Ho Minh Tam'; // hoặc lấy từ dữ liệu

      //if (tickets.isEmpty) {
        emit(TicketCheckFailure('Không tìm thấy vé nào'));
      //} else {
        //emit(TicketCheckSuccess(name: buyerName, tickets: tickets));
      }
    //} catch (e) {
      //emit(TicketCheckFailure('Lỗi xảy ra khi tra cứu'));
    //}
  //}
//}