import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_ticket/blocs/news_detail/news_match_detail_bloc.dart';
import 'package:football_ticket/blocs/news_detail/news_match_detail_event.dart';
import 'package:football_ticket/blocs/news_detail/news_match_detail_state.dart';
import 'package:football_ticket/models/news_match_model.dart';
import 'package:football_ticket/repositories/news_match_detail_repository.dart';

class NewsDetailScreen extends StatelessWidget {
  final NewsMatchModel newsMatch;
  final NewsMatchDetailRepository repository;

  const NewsDetailScreen({
    super.key,
    required this.newsMatch,
    required this.repository,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewsMatchDetailBloc(repository: repository)
        ..add(FetchNewsMatchDetail(matchId: newsMatch.matchId)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Chi tiết tin tức"),
        ),
        body: BlocBuilder<NewsMatchDetailBloc, NewsMatchDetailState>(
          builder: (context, state) {
            if (state is NewsMatchDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is NewsMatchDetailLoaded) {
              final match = state.detail;

              return SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    // Logo và tên đội
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Image.network(
                              'https://intership.hqsolutions.vn${match.homeTeamLogo}',
                              width: 80,
                              height: 80,
                              errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.image),
                            ),
                            Text(
                              match.homeTeamName,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                        Text(
                          "${match.homeScore} - ${match.awayScore}",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Column(
                          children: [
                            Image.network(
                              'https://intership.hqsolutions.vn${match.awayTeamLogo}',
                              width: 80,
                              height: 80,
                              errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.image),
                            ),
                            Text(
                              match.awayTeamName,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "Thời gian: ${match.matchDateTime}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Danh sách ghi bàn:",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          if (match.homeTeamGoals.isEmpty &&
                              match.awayTeamGoals.isEmpty)
                            const Text("Chưa có cầu thủ ghi bàn"),
                          ...match.homeTeamGoals.map((goal) => Text(
                              "${goal.playerName} (${goal.goalTime}') - ${match.homeTeamName}")),
                          ...match.awayTeamGoals.map((goal) => Text(
                              "${goal.playerName} (${goal.goalTime}') - ${match.awayTeamName}")),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              );
            } else if (state is NewsMatchDetailError) {
              return Center(child: Text("Lỗi: ${state.message}"));
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}