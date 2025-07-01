import 'package:equatable/equatable.dart';

class MatchDetailsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadMatchDetailsEvent extends MatchDetailsEvent {
  final String token;
  final String idMatch;
  LoadMatchDetailsEvent(this.token, this.idMatch);

  @override
  List<Object?> get props => [idMatch, token];
}
