import 'package:equatable/equatable.dart';

abstract class NewsMatchDetailEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchNewsMatchDetail extends NewsMatchDetailEvent {
  final String matchId;

  FetchNewsMatchDetail({required this.matchId});

  @override
  List<Object?> get props => [matchId];
}
