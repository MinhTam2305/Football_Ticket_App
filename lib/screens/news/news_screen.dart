import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '/blocs/news_match/news_match_bloc.dart';
import '/blocs/news_match/news_match_event.dart';
import '/blocs/news_match/news_match_state.dart';
import '/models/news_match_model.dart';
import '/screens/news/news_detail_screen.dart';
import '/repositories/news_match_detail_repository.dart';
import '/core/constants/colors.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NewsMatchBloc>().add(FetchNewsMatchEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary_bg,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        centerTitle: true,
        title: const Text("News", style: TextStyle(color: Colors.white)),
      ),
      body: BlocBuilder<NewsMatchBloc, NewsMatchState>(
        builder: (context, state) {
          if (state is NewsMatchLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NewsMatchLoaded) {
            final groupedMatches = _groupMatchesByDate(state.newsMatches);

            return ListView.builder(
              itemCount: groupedMatches.keys.length,
              itemBuilder: (context, index) {
                String dateKey = groupedMatches.keys.elementAt(index);
                List<NewsMatchModel> matches = groupedMatches[dateKey]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Text(
                        dateKey,
                        style: AppTextStyles.body1,
                      ),
                    ),
                    ...matches.map((match) => _buildMatchCard(match)).toList(),
                  ],
                );
              },
            );
          } else {
            return const Center(child: Text("Failed to load news_match"));
          }
        },
      ),
    );
  }

  Widget _buildMatchCard(NewsMatchModel match) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => NewsDetailScreen(
              newsMatch: match,
              repository: NewsMatchDetailRepository(), // ✅ THÊM DÒNG NÀY
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(2, 2),
            )
          ],
        ),
        child: Row(
          children: [
            // Logo home team
            Image.network(
              'https://intership.hqsolutions.vn${match.homeTeamLogo}',
              width: 50,
              height: 50,
              errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.image_not_supported),
            ),
            const SizedBox(width: 8),
            // VS info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${match.homeTeamName} ${match.homeScore} - ${match.awayScore} ${match.awayTeamName}",
                    style: AppTextStyles.body1,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    match.matchDate,
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
            // Logo away team
            Image.network(
              'https://intership.hqsolutions.vn${match.awayTeamLogo}',
              width: 50,
              height: 50,
              errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.image_not_supported),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, List<NewsMatchModel>> _groupMatchesByDate(
      List<NewsMatchModel> matches) {
    Map<String, List<NewsMatchModel>> grouped = {};

    for (var match in matches) {
      final date = DateFormat("dd/MM/yyyy").parse(match.matchDate);
      final today = DateTime.now();
      final yesterday = today.subtract(const Duration(days: 1));

      String key;
      if (_isSameDay(date, today)) {
        key = "Today";
      } else if (_isSameDay(date, yesterday)) {
        key = "Yesterday";
      } else {
        key = DateFormat("dd/MM").format(date);
      }

      grouped.putIfAbsent(key, () => []).add(match);
    }

    return grouped;
  }

  bool _isSameDay(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }
}