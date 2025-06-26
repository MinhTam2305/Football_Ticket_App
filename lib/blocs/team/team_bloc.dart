import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_ticket/blocs/team/team_event.dart';
import 'package:football_ticket/blocs/team/team_state.dart';
import 'package:football_ticket/repositories/team_repository.dart';

class TeamBloc extends Bloc<TeamEvent, TeamState> {
  final TeamRepository _teamRepository;

  TeamBloc(this._teamRepository) : super(TeamInitial()) {
    on<LoadTeamByEvent>((event, state) async {
      emit(TeamLoading());
      try {
        final team = await _teamRepository.getTeamById(event.id);
        emit(TeamLoaded(team));
      } catch (e) {
        emit(TeamLoadError("Team Load Error: e"));
      }
    });
  }
}
