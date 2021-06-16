import 'package:flutter/material.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';

final lightTheme = ThemeData(
  brightness: Brightness.light,
  backgroundColor: AppColors.backgroundLight,
  scaffoldBackgroundColor: AppColors.backgroundLight,
  appBarTheme: const AppBarTheme(
    color: AppColors.backgroundLight,
    elevation: 0,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: AppColors.backgroundDark,
    selectedIconTheme: const IconThemeData(color: AppColors.backgroundLight),
    unselectedIconTheme: IconThemeData(color: AppColors.backgroundLight.withOpacity(0.8)),
    selectedLabelStyle: const TextStyle(color: AppColors.primaryTextDark),
    unselectedLabelStyle: TextStyle(color: AppColors.primaryTextDark.withOpacity(0.8)),
  ),
  tabBarTheme: const TabBarTheme(
    labelColor: AppColors.primaryTextLight,
    unselectedLabelColor: AppColors.primaryTextLight,
  ),
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  backgroundColor: AppColors.backgroundDark,
  appBarTheme: const AppBarTheme(
    color: AppColors.backgroundDark,
    elevation: 0,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: AppColors.backgroundLight,
    type: BottomNavigationBarType.fixed,
    selectedIconTheme: const IconThemeData(color: AppColors.backgroundDark),
    unselectedIconTheme: IconThemeData(color: AppColors.backgroundDark.withOpacity(0.8)),
    selectedLabelStyle: const TextStyle(color: AppColors.primaryTextLight),
    unselectedLabelStyle: TextStyle(color: AppColors.primaryTextLight.withOpacity(1)),
  ),
  tabBarTheme: const TabBarTheme(
    labelColor: AppColors.primaryTextDark,
    unselectedLabelColor: AppColors.primaryTextDark,
  ),
);
