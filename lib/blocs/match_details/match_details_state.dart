import 'package:equatable/equatable.dart';
import 'package:football_ticket/models/match_details_model.dart';

class MatchDetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MatchDetailsInitial extends MatchDetailsState {}

class MatchDetailsLoading extends MatchDetailsState {}

class MatchDetailsLoaded extends MatchDetailsState {
  final MatchDetailsModel detailsMatch;
  MatchDetailsLoaded(this.detailsMatch);
  @override
  List<Object?> get props => [detailsMatch];
}

class MatchDetailsError extends MatchDetailsState {
  final String message;
  MatchDetailsError(this.message);
  @override
  List<Object?> get props => [message];
}
