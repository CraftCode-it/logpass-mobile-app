import 'package:flutter/material.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';

final lightTheme = ThemeData(
  brightness: Brightness.light,
  backgroundColor: AppColors.backgroundLight,
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: AppColors.backgroundDark,
    selectedIconTheme: const IconThemeData(color: AppColors.backgroundLight),
    unselectedIconTheme: IconThemeData(color: AppColors.backgroundLight.withOpacity(0.8)),
    selectedLabelStyle: const TextStyle(color: AppColors.primaryTextDark),
    unselectedLabelStyle: TextStyle(color: AppColors.primaryTextDark.withOpacity(0.8)),
  ),
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  backgroundColor: AppColors.backgroundDark,
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: AppColors.backgroundLight,
    type: BottomNavigationBarType.fixed,
    selectedIconTheme: const IconThemeData(color: AppColors.backgroundDark),
    unselectedIconTheme: IconThemeData(color: AppColors.backgroundDark.withOpacity(0.8)),
    selectedLabelStyle: const TextStyle(color: AppColors.primaryTextLight),
    unselectedLabelStyle: TextStyle(color: AppColors.primaryTextLight.withOpacity(1)),
  ),
);
