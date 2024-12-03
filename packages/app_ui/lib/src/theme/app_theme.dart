import 'package:app_ui/app_ui.dart';
import 'package:app_ui/src/generated/fonts.gen.dart';
import 'package:flutter/material.dart';

/// Namespace for the app's themes.
abstract final class AppTheme {
  /// {@macro app_ui.app_theme}
  static final themeData = ThemeData(
    appBarTheme: _appBarTheme,
    tabBarTheme: _tabBarTheme,
    colorScheme: _colorScheme,
    textTheme: _textTheme,
    fontFamily: FontFamily.montserrat,
  );

  static const _colorScheme = ColorScheme.light(
    primary: AppColors.mainBlue,
  );

  static final _textTheme = TextTheme(
    displayLarge: AppTextStyle.headline1,
    displayMedium: AppTextStyle.headline2,
    displaySmall: AppTextStyle.headline3,
    headlineMedium: AppTextStyle.headline4,
    headlineSmall: AppTextStyle.headline5,
    titleLarge: AppTextStyle.headline6,
    titleMedium: AppTextStyle.subtitle1,
    titleSmall: AppTextStyle.subtitle2,
    bodyLarge: AppTextStyle.bodyText1,
    bodyMedium: AppTextStyle.bodyText2,
    labelLarge: AppTextStyle.button,
    bodySmall: AppTextStyle.caption,
    labelSmall: AppTextStyle.overline,
  ).apply(
    bodyColor: AppColors.black,
    displayColor: AppColors.black,
    decorationColor: AppColors.black,
  );

  static final _appBarTheme = AppBarTheme(
    backgroundColor: AppColors.mainBlue,
    foregroundColor: AppColors.white,
    titleTextStyle: AppTextStyle.headline3.copyWith(
      color: AppColors.white,
    ),
  );

  static const _tabBarTheme = TabBarTheme(
    labelColor: AppColors.mainBlue,
    indicatorColor: AppColors.mainBlue,
    dividerColor: AppColors.mainBlue,
    dividerHeight: AppSpacing.xxxsm / 2,
  );
}
