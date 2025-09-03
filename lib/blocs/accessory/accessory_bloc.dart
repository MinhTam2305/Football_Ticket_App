import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_ticket/blocs/accessory/accessory_event.dart';
import 'package:football_ticket/blocs/accessory/accessory_state.dart';
import 'package:football_ticket/repositories/accessory_repository.dart';

class AccessoryBloc extends Bloc<AccessoryEvent, AccessoryState> {
  final AccessoryRepository _accessoryRepository;
  AccessoryBloc(this._accessoryRepository) : super(ListAccessoryInitial()) {
    on<LoadListAccessoryEvent>(_loadAccessory);
  }
  Future<void> _loadAccessory(
    LoadListAccessoryEvent event,
    Emitter<AccessoryState> emit,
  ) async {
    emit(ListAccessoryLoading());
    try {
      final listAccessory = await _accessoryRepository.fetchAccessories(
        bearerToken: event.token,
      );

      emit(ListAccessoryLoaded(listAccessory));
    } catch (e) {
      emit(ListAccessoryError(e.toString()));
    }
  }
}
