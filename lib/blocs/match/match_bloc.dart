import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_ticket/blocs/match/match_event.dart';
import 'package:football_ticket/blocs/match/match_state.dart';
import 'package:football_ticket/models/match_model.dart';
import 'package:football_ticket/repositories/match_repository.dart';

class MatchBloc extends Bloc<MatchEvent, MatchState> {
  final MatchRepository _matchRepository;
  MatchBloc(this._matchRepository) : super(MatchInitial()) {
    on<LoadMatchEvent>(_loadMatch);
  }

  Future<void> _loadMatch(
    LoadMatchEvent event,
    Emitter<MatchState> emit,
  ) async {
    emit(MatchLoading());
    try {
      List<MatchModel> listMatch;
      if (event.idTeam != null) {
        listMatch = await _matchRepository.getMatch(event.idTeam);
        emit(MatchLoaded(listMatch));
      } else {
        listMatch = await _matchRepository.getMatch(null);
        emit(MatchLoaded(listMatch));
      }

      for (var match in listMatch) {
        print("---------------------");
        print(match);
      }
    } catch (e) {
      emit(MatchLoadError(e.toString()));
    }
  }
}
