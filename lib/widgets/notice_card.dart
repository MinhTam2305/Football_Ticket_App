import 'package:flutter/material.dart';
import 'package:football_ticket/core/constants/colors.dart';

class NoticeCard extends StatelessWidget {
  final String title;
  final String content;
  final bool isOpened;
  const NoticeCard({
    super.key,
    required this.title,
    required this.content,
    required this.isOpened,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 100,
      child: Card(
        elevation: isOpened ? 1 : 5,
        color: isOpened ? AppColors.white : Color.fromARGB(255, 243, 243, 243),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.body1),
              Text(
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                content,
                style: AppTextStyles.body2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
