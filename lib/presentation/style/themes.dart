import 'package:flutter/material.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';

final lightTheme = ThemeData(
  brightness: Brightness.light,
  backgroundColor: AppColors.backgroundDark,
  // otherwise transition from native splash screen to flutter blinks with white color
  scaffoldBackgroundColor: AppColors.backgroundDark,
  appBarTheme: const AppBarTheme(
    color: AppColors.backgroundLight,
    elevation: 0,
  ),
  tabBarTheme: TabBarTheme(
    labelStyle: _tabBarSelectedTypography(),
    unselectedLabelStyle: _tabBarUnselectedTypography(),
    labelColor: AppColors.primary100,
    unselectedLabelColor: AppColors.primary20,
  ),
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  backgroundColor: AppColors.backgroundDark,
  scaffoldBackgroundColor: AppColors.backgroundDark,
  appBarTheme: const AppBarTheme(
    color: AppColors.backgroundDark,
    elevation: 0,
  ),
  tabBarTheme: TabBarTheme(
    labelStyle: _tabBarSelectedTypography(),
    unselectedLabelStyle: _tabBarUnselectedTypography(),
    labelColor: AppColors.primary10,
    unselectedLabelColor: AppColors.primary80,
  ),
);

TextStyle _tabBarSelectedTypography() {
  return const TextStyle(
    fontSize: 16,
    letterSpacing: 0,
    fontWeight: FontWeight.w600,
  );
}

TextStyle _tabBarUnselectedTypography() {
  return const TextStyle(
    fontSize: 16,
    letterSpacing: 0,
    fontWeight: FontWeight.w400,
  );
}
