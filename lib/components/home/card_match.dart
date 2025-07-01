import 'package:flutter/material.dart';
import 'package:football_ticket/core/constants/colors.dart';
import 'package:football_ticket/models/match_model.dart';

class CardMatch extends StatelessWidget {
  final MatchModel match;
  const CardMatch({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 170,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary, width: 2),
        ),
        child: Column(
          children: [
            SizedBox(height: 5),
            Text(
              "V-lEAGUE 2025",
              style: AppTextStyles.body1.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Image.network(
                      match.homeTeam.logo,
                      width: 60,
                      height: 50,
                    ),
                    Text(match.homeTeam.teamName, style: AppTextStyles.body1),
                  ],
                ),

                Column(
                  children: [
                    Image.network(
                      match.awayTeam.logo,
                      width: 60,
                      height: 50,
                    ),
                    Text(match.awayTeam.teamName, style: AppTextStyles.body1),
                  ],
                ),
              ],
            ),
            Text(
              "VS",
              style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.bold),
            ),
            Divider(color: AppColors.secondary),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Icon(Icons.timer_sharp, color: AppColors.grey),
                    SizedBox(width: 5),
                    Text(match.matchDate, style: AppTextStyles.body2),
                    SizedBox(width: 8),
                    Text(match.matchTime, style: AppTextStyles.body2),
                  ],
                ),
                SizedBox(width: 70),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, color: AppColors.grey),
                    SizedBox(width: 5),
                    Text("Go Dau", style: AppTextStyles.body2),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
