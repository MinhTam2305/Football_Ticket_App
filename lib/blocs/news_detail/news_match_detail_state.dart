import 'package:equatable/equatable.dart';
import '/models/news_match_detail_model.dart';

abstract class NewsMatchDetailState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NewsMatchDetailInitial extends NewsMatchDetailState {}

class NewsMatchDetailLoading extends NewsMatchDetailState {}

class NewsMatchDetailLoaded extends NewsMatchDetailState {
  final NewsMatchDetailModel detail;

  NewsMatchDetailLoaded({required this.detail});

  @override
  List<Object?> get props => [detail];
}

class NewsMatchDetailError extends NewsMatchDetailState {
  final String message;

  NewsMatchDetailError({required this.message});

  @override
  List<Object?> get props => [message];
}