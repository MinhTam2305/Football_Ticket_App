import 'package:equatable/equatable.dart';
import 'package:football_ticket/models/team_model.dart';

abstract class TeamState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TeamInitial extends TeamState {}

class TeamLoading extends TeamState {}

class TeamLoaded extends TeamState {
  final TeamModel teamModel;
  TeamLoaded(this.teamModel);

  @override
  List<Object?> get props => [teamModel];
}

class TeamLoadError extends TeamState {
  final String message;
  TeamLoadError(this.message);
  @override
  List<Object?> get props => [message];
}
