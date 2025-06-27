import 'package:equatable/equatable.dart';

abstract class MatchEvent extends Equatable {
  @override
  List<Object?> get props => throw [];
}

class LoadMatchEvent extends MatchEvent {
  final String? idTeam;
  LoadMatchEvent(this.idTeam);
  @override
  List<Object?> get props => [idTeam];
}
