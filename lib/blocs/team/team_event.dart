import 'package:equatable/equatable.dart';

abstract class TeamEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadTeamByIdEvent extends TeamEvent {
  final String id;

  LoadTeamByIdEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class LoadTeamEvent extends TeamEvent {}
