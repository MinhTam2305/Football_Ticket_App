import 'package:flutter_bloc/flutter_bloc.dart';
import 'news_event.dart';
import 'news_state.dart';
import '../../repositories/news_repository.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final NewsRepository repository;

  NewsBloc(this.repository) : super(NewsInitial()) {
    on<FetchNewsEvent>((event, emit) async {
      emit(NewsLoading());
      try {
        final newsList = await repository.fetchNews();
        emit(NewsLoaded(newsList));
      } catch (e) {
        emit(NewsError(e.toString()));
      }
    });
  }
}