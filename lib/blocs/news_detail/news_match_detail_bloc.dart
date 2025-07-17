import 'package:flutter_bloc/flutter_bloc.dart';
import 'news_match_detail_event.dart';
import 'news_match_detail_state.dart';
import '/repositories/news_match_detail_repository.dart';

class NewsMatchDetailBloc extends Bloc<NewsMatchDetailEvent, NewsMatchDetailState> {
  final NewsMatchDetailRepository repository;

  NewsMatchDetailBloc({required this.repository}) : super(NewsMatchDetailInitial()) {
    on<FetchNewsMatchDetail>(_onFetchNewsMatchDetail);
  }

  Future<void> _onFetchNewsMatchDetail(
      FetchNewsMatchDetail event,
      Emitter<NewsMatchDetailState> emit,
      ) async {
    emit(NewsMatchDetailLoading());
    try {
      final detail = await repository.fetchNewsMatchDetail(event.matchId);
      emit(NewsMatchDetailLoaded(detail: detail));
    } catch (e) {
      emit(NewsMatchDetailError(message: e.toString()));
    }
  }
}