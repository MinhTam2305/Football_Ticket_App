import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_ticket/blocs/team/team_event.dart';
import 'package:football_ticket/blocs/team/team_state.dart';
import 'package:football_ticket/repositories/team_repository.dart';

class TeamBloc extends Bloc<TeamEvent, TeamState> {
  final TeamRepository _teamRepository;

  TeamBloc(this._teamRepository) : super(TeamInitial()) {
    on<LoadTeamEvent>(_loadTeam);
    on<LoadTeamByIdEvent>(_loadTeamById);
  }


    Future<void> _loadTeam(
    LoadTeamEvent event,
    Emitter<TeamState> emit,
  ) async {
    try {
      final team = await _teamRepository.getTeam();
      emit(TeamLoaded(team));
    } catch (e) {
      emit(TeamLoadError("Team Load Error: e"));
    }
  }
  Future<void> _loadTeamById(
    LoadTeamByIdEvent event,
    Emitter<TeamState> emit,
  ) async {
    try {
      final team = await _teamRepository.getTeamById(event.id);
      emit(TeamByIdLoaded(team));
    } catch (e) {
      emit(TeamLoadError("Team Load Error: e"));
    }
  }
}
