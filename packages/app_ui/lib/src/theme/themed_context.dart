import 'package:flutter/material.dart';

/// Extension methods for [BuildContext] to access theme properties.
extension ThemedContext on BuildContext {
  /// The current [ThemeData] of the app.
  ThemeData get theme => Theme.of(this);

  /// The current [TextTheme] of the app.
  TextTheme get textTheme => theme.textTheme;

  /// The current [ColorScheme] of the app.
  ColorScheme get colorScheme => theme.colorScheme;
}
