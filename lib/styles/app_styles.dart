import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  static const Color textColorBlack = AppColors.textColorBlack;
  static const Color textColorWhite = AppColors.textColorWhite;
  static const double defaultOpacity = 1;

  static TextStyle title({
    Color color = AppColors.textColorBlack,
    double opacity = defaultOpacity,
  }) {
    return TextStyle(
        color: color.withOpacity(opacity),
        fontSize: 20,
        fontWeight: FontWeight.bold);
  }

  static TextStyle bookCardTitle(
      {Color color = AppColors.textColorWhite,
      double opacity = defaultOpacity}) {
    return TextStyle(
      color: color.withOpacity(opacity),
      fontSize: 36,
    );
  }

  static TextStyle titleDrawer(
      {Color color = textColorWhite, double opacity = defaultOpacity}) {
    return TextStyle(color: color.withOpacity(opacity), fontSize: 24);
  }

  static TextStyle titleLogin(
      {Color color = AppColors.textColorBlack,
      double opacity = defaultOpacity}) {
    return TextStyle(color: color, fontSize: 25, fontWeight: FontWeight.bold);
  }
}
