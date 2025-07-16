import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../models/news_model.dart';
import '../../core/constants/colors.dart';

class NewsDetailScreen extends StatelessWidget {
  final NewsItem news;

  const NewsDetailScreen({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary_bg,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(news.title, style: const TextStyle(color: Colors.white)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (news.imageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(news.imageUrl!),
            ),
          const SizedBox(height: 16),
          Html(data: news.content),
        ],
      ),
    );
  }
}