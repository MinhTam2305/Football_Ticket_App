import '../../models/news_model.dart';

abstract class NewsState {}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {}

class NewsLoaded extends NewsState {
  final List<NewsItem> newsList;

  NewsLoaded(this.newsList);
}

class NewsError extends NewsState {
  final String message;

  NewsError(this.message);
}