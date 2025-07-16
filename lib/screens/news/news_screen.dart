import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../blocs/news/news_bloc.dart';
import '../../blocs/news/news_event.dart';
import '../../blocs/news/news_state.dart';
import '../../models/news_model.dart';
import '../../core/constants/colors.dart';
import 'news_detail_screen.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NewsBloc>().add(FetchNewsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary_bg,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('News', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: BlocBuilder<NewsBloc, NewsState>(
        builder: (context, state) {
          if (state is NewsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NewsLoaded) {
            final grouped = _groupByDate(state.newsList);
            return ListView(
              padding: const EdgeInsets.all(16),
              children: grouped.entries.map((entry) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(entry.key, style: AppTextStyles.title2),
                    const SizedBox(height: 10),
                    ...entry.value.map((item) => _buildItem(context, item)),
                    const SizedBox(height: 20),
                  ],
                );
              }).toList(),
            );
          } else if (state is NewsError) {
            return Center(child: Text(state.message));
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  Widget _buildItem(BuildContext context, NewsItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: item.imageUrl != null
            ? Image.network(item.imageUrl!, width: 60, height: 60, fit: BoxFit.cover)
            : const Icon(Icons.image_not_supported),
        title: Text(item.title, style: AppTextStyles.body1),
        subtitle: Text(DateFormat('dd/MM/yyyy HH:mm').format(item.createdAt),
            style: AppTextStyles.caption),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondary),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => NewsDetailScreen(news: item)),
            );
          },
          child: const Text("View", style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  Map<String, List<NewsItem>> _groupByDate(List<NewsItem> list) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    Map<String, List<NewsItem>> grouped = {};
    for (var item in list) {
      final date = DateTime(item.createdAt.year, item.createdAt.month, item.createdAt.day);
      String key;
      if (date == today) {
        key = 'Today';
      } else if (date == yesterday) {
        key = 'Yesterday';
      } else {
        key = DateFormat('dd/MM').format(date);
      }
      grouped.putIfAbsent(key, () => []).add(item);
    }
    return grouped;
  }
}