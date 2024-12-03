import 'package:app_ui/app_ui.dart';
import 'package:app_ui/src/generated/fonts.gen.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

/// Namespace for the [TextStyle]s used in the app.
abstract final class AppTextStyle {
  /// The base [TextStyle] for the app.
  @internal
  static const baseTextStyle = TextStyle(
    fontWeight: AppFontWeight.regular,
    height: 1.5,
    package: 'app_ui',
    fontFamily: FontFamily.montserrat,
  );

  /// Headline 1 Text Style
  static final TextStyle headline1 = baseTextStyle.copyWith(
    fontSize: 32,
    fontWeight: AppFontWeight.bold,
    height: 1.25,
  );

  /// Headline 2 Text Style
  static final TextStyle headline2 = baseTextStyle.copyWith(
    fontSize: 26,
    fontWeight: AppFontWeight.extraBold,
    height: 1.25,
  );

  /// Headline 3 Text Style
  static final TextStyle headline3 = baseTextStyle.copyWith(
    fontSize: 22,
    fontWeight: AppFontWeight.extraBold,
    height: 1.25,
  );

  /// Headline 4 Text Style
  static final TextStyle headline4 = baseTextStyle.copyWith(
    fontSize: 20,
    fontWeight: AppFontWeight.extraBold,
    height: 1.25,
  );

  /// Headline 5 Text Style
  static final TextStyle headline5 = baseTextStyle.copyWith(
    fontSize: 18,
    fontWeight: AppFontWeight.extraBold,
    height: 1.25,
  );

  /// Headline 6 Text Style
  static final TextStyle headline6 = baseTextStyle.copyWith(
    fontSize: 14,
    fontWeight: AppFontWeight.bold,
    height: 1.25,
  );

  /// Subtitle 1 Text Style
  static final TextStyle subtitle1 = baseTextStyle.copyWith(
    fontSize: 16,
  );

  /// Subtitle 2 Text Style
  static final TextStyle subtitle2 = baseTextStyle.copyWith(
    fontSize: 14,
  );

  /// Body Text 1 Text Style
  static final TextStyle bodyText1 = baseTextStyle.copyWith(
    fontSize: 14,
  );

  /// Body Text 2 Text Style (the default)
  static final TextStyle bodyText2 = baseTextStyle.copyWith(
    fontSize: 16,
  );

  /// Button Text Style
  static final TextStyle button = baseTextStyle.copyWith(
    fontSize: 16,
    fontWeight: AppFontWeight.bold,
  );

  /// Caption Text Style
  static final TextStyle caption = baseTextStyle.copyWith(
    fontSize: 12,
  );

  /// Overline Text Style
  static final TextStyle overline = baseTextStyle.copyWith(
    fontSize: 10,
    fontWeight: AppFontWeight.medium,
  );
}
