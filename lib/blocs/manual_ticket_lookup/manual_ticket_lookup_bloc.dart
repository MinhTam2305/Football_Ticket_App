import 'package:flutter_bloc/flutter_bloc.dart';
import 'manual_ticket_lookup_event.dart';
import 'manual_ticket_lookup_state.dart';
import '../../repositories/manual_ticket_lookup_repository.dart';

class ManualTicketLookupBloc
    extends Bloc<ManualTicketLookupEvent, ManualTicketLookupState> {
  final ManualTicketLookupRepository repository;

  ManualTicketLookupBloc({required this.repository})
      : super(ManualTicketLookupInitial()) {
    on<LookupTicketEvent>((event, emit) async {
      emit(ManualTicketLookupLoading());
      try {
        final ticket = await repository.lookupTicket(event.code);
        emit(ManualTicketLookupSuccess(ticket));
      } catch (e) {
        emit(ManualTicketLookupFailure(e.toString()));
      }
    });
  }
}