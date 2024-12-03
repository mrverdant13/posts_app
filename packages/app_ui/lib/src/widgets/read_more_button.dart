import 'package:app_ui/app_ui.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// {@template app_ui.read_more_button}
/// The "Read More" button for a [PostCard].
/// {@endtemplate}
class ReadMoreButton extends StatelessWidget {
  /// {@macro app_ui.read_more_button}
  const ReadMoreButton({
    required this.details,
    super.key,
  });

  /// The button details.
  final ReadMoreButtonDetails details;

  /// The [TextStyle] for the button label.
  static final labelStyle = AppTextStyle.baseTextStyle.copyWith(
    fontSize: 16,
    fontWeight: AppFontWeight.medium,
    height: 1,
  );

  /// The size of the icon.
  static const iconSize = 16.0;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      label: Text(details.label),
      style: TextButton.styleFrom(
        foregroundColor: AppColors.accentBlue,
        alignment: Alignment.centerLeft,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
        textStyle: labelStyle,
      ),
      icon: details.icon != null
          ? Icon(
              details.icon,
              size: iconSize,
            )
          : null,
      iconAlignment: IconAlignment.end,
      onPressed: details.onTap,
    );
  }
}

/// {@template app_ui.read_more_button_details}
/// The details for a [ReadMoreButton].
/// {@endtemplate}
class ReadMoreButtonDetails extends Equatable {
  /// {@macro app_ui.read_more_button_details}
  const ReadMoreButtonDetails({
    required this.label,
    required this.onTap,
    this.icon,
  });

  /// The label for the "Read More" button.
  final String label;

  /// The icon for the "Read More" button.
  final IconData? icon;

  /// The callback for the "Read More" button.
  final VoidCallback onTap;

  @override
  List<Object?> get props => [label, icon, onTap];
}
