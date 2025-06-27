import 'package:equatable/equatable.dart';
import 'package:football_ticket/models/match_model.dart';

abstract class MatchState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MatchInitial extends MatchState {}

class MatchLoading extends MatchState {}

class MatchLoaded extends MatchState {
  final List<MatchModel> listMatch;
  MatchLoaded(this.listMatch);

  @override
  List<Object?> get props => [listMatch];
}

class MatchLoadError extends MatchState {
  final String message;
  MatchLoadError(this.message);

  @override
  List<Object?> get props => [message];
}
