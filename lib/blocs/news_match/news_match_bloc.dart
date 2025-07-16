import 'package:flutter_bloc/flutter_bloc.dart';
import 'news_match_event.dart';
import 'news_match_state.dart';
import '../../repositories/news_match_repository.dart';

class NewsMatchBloc extends Bloc<NewsMatchEvent, NewsMatchState> {
  final NewsMatchRepository repository;

  NewsMatchBloc({required this.repository}) : super(NewsMatchInitial()) {
    on<FetchNewsMatchEvent>((event, emit) async {
      emit(NewsMatchLoading());
      try {
        final matches = await repository.fetchNewsMatches();
        emit(NewsMatchLoaded(matches));
      } catch (e) {
        emit(NewsMatchError(e.toString()));
      }
    });
  }
}