import 'package:flutter/material.dart';

import '../core/constants/colors.dart';

Widget textFieldCustom(String label, IconData icon,TextEditingController controller, bool obscureText) {
  return TextField(
    controller: controller,
    obscureText: obscureText,
    decoration: InputDecoration(
      labelText: label,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.secondary, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.primary, width: 2),
      ),
      prefixIcon: Icon(icon),
    ),
  );
}
