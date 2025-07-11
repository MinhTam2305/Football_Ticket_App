import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF0D47A1);
  static const secondary = Color(0xFF61A9F0);
  static const success = Color(0xFF4CAF50);
  static const error = Color(0xFFD32F2F);
  static const warning = Color(0xFFFFA000);
  static const background = Color(0xFFF5F5F5);
  //   static const background = Color.fromARGB(255, 212, 225, 235);
  static const textMain = Color(0xFF212121);
  static const textSub = Color(0xFF757575);
  static const white = Color(0xFFFFFFFF);
  static const grey = Color(0xFF757575);
  static const secondary_bg = Color.fromARGB(255, 208, 221, 230);
}

class AppTextStyles {
  static const title1 = TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
  static const title2 = TextStyle(fontSize: 20, fontWeight: FontWeight.w600);
  static const body1 = TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
  static const body2 = TextStyle(fontSize: 14, fontWeight: FontWeight.w400);
  static const caption = TextStyle(fontSize: 12, fontWeight: FontWeight.w300);
  static const button = TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
  static const error = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.error,
  );
}
