import 'package:flutter/material.dart';
import '../core/constants/colors.dart';

class ButtonCustom extends StatelessWidget {
  final void Function()? opTap;
  final String text;
  bool isLoading = false;

  ButtonCustom({
    super.key,
    required this.text,
    required this.opTap,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: opTap,
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child:
              isLoading
                  ? CircularProgressIndicator(color: AppColors.white)
                  : Text(
                    text,
                    style: AppTextStyles.title1.copyWith(
                      color: AppColors.white,
                    ),
                  ),
        ),
      ),
    );
  }
}
