import 'package:app_ui/app_ui.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// {@template app_ui.post_category_chip}
/// A chip that displays a post category.
/// {@endtemplate}
class PostCategoryChip extends StatelessWidget {
  /// {@macro app_ui.post_category_chip}
  const PostCategoryChip({
    required this.details,
    super.key,
  });

  /// The chip details.
  final PostCategoryChipDetails details;

  /// The [TextStyle] for the label.
  static final labelStyle = AppTextStyle.baseTextStyle.copyWith(
    fontSize: 12,
    height: 1,
  );

  @override
  Widget build(BuildContext context) {
    final PostCategoryChipDetails(:label, :color) = details;
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color,
        shape: const StadiumBorder(),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        child: Text(
          label,
          style: labelStyle.copyWith(
            color: color.computeLuminance() > 0.5
                ? AppColors.black
                : AppColors.white,
          ),
        ),
      ),
    );
  }
}

/// {@template app_ui.post_category_chip_details}
/// The details for a [PostCategoryChip].
/// {@endtemplate}
class PostCategoryChipDetails extends Equatable {
  /// {@macro app_ui.post_category_chip_details}
  const PostCategoryChipDetails({
    required this.label,
    required this.color,
  });

  /// The label for the category.
  final String label;

  /// The color for the category.
  final Color color;

  @override
  List<Object> get props => [label, color];
}
