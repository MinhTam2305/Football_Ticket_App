import '../../models/news_match_model.dart';

abstract class NewsMatchState {}

class NewsMatchInitial extends NewsMatchState {}

class NewsMatchLoading extends NewsMatchState {}

class NewsMatchLoaded extends NewsMatchState {
  final List<NewsMatchModel> newsMatches;

  NewsMatchLoaded(this.newsMatches);
}

class NewsMatchError extends NewsMatchState {
  final String message;
  NewsMatchError(this.message);
}
