import 'package:equatable/equatable.dart';

abstract class TeamEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadTeamByEvent extends TeamEvent {
  final String id;

  LoadTeamByEvent(this.id);

  @override
  List<Object?> get props => [id];
}
