import 'package:flutter/widgets.dart';
import 'package:football_ticket/core/constants/colors.dart';

class CardStand extends StatelessWidget {
  final String stand;
  final String quantity;
  bool isTarget = false;
  CardStand({
    super.key,
    required this.stand,
    required this.quantity,
    this.isTarget = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      height: 45,
      decoration: BoxDecoration(
        color: isTarget? AppColors.secondary: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary, width: 2),
      ),
      child: Column(
        children: [
          Text(
            "Stand $stand",
            style: AppTextStyles.body2.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            quantity,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
