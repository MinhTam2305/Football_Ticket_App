import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_ticket/blocs/match_details/match_details_event.dart';
import 'package:football_ticket/blocs/match_details/match_details_state.dart';
import 'package:football_ticket/repositories/match_details_repository.dart';

class MatchDetailsBloc extends Bloc<MatchDetailsEvent, MatchDetailsState> {
  final MatchDetailsRepository _matchDetailsRepo;
  MatchDetailsBloc(this._matchDetailsRepo) : super(MatchDetailsInitial()) {
    on<LoadMatchDetailsEvent>(_loadMatchDetail);
  }
  Future<void> _loadMatchDetail(
    LoadMatchDetailsEvent event,
    Emitter<MatchDetailsState> emit,
  ) async {
    emit(MatchDetailsLoading());
    try {
      final listMatch = await _matchDetailsRepo.getMatch(event.token,event.idMatch);
      emit(MatchDetailsLoaded(listMatch));
    } catch (e) {
      emit(MatchDetailsError(e.toString()));
    }
  }
}
