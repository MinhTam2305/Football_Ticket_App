import 'package:flutter/material.dart';
import 'package:football_ticket/core/constants/colors.dart';
import 'package:football_ticket/widgets/button_custom.dart';

class Report extends StatelessWidget {
  const Report({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        centerTitle: true,
        title: Text("Report Error", style: AppTextStyles.title1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Problem", style: AppTextStyles.title2),
            SizedBox(height: 10),
            TextField(
              minLines: 4,
              maxLines: null,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.primary, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.primary, width: 2),
                ),
              ),
            ),
            SizedBox(height: 100),
            ButtonCustom(text: "Send", opTap: () {}, isLoading: false),
          ],
        ),
      ),
    );
  }
}
