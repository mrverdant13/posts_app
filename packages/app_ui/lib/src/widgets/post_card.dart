import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// {@template app_ui.post_card}
/// A card that displays a post.
/// {@endtemplate}
class PostCard extends StatelessWidget {
  /// {@macro app_ui.post_card}
  const PostCard({
    required this.title,
    required this.body,
    this.onTitleTap,
    this.category,
    this.readMore,
    this.footer,
    super.key,
  }) : isSkeleton = false;

  /// A skeleton [PostCard].
  const PostCard.skeleton({
    super.key,
    bool hasCategory = false,
    bool hasReadMore = false,
    Widget? footerPrototype,
  })  : title = 'A Fake Post Title',
        body = 'A fake post body.' * 8,
        onTitleTap = _noAction,
        category = hasCategory
            ? const PostCategoryChipDetails(
                label: 'Category',
                color: AppColors.grey,
              )
            : null,
        readMore = hasReadMore
            ? const ReadMoreButtonDetails(
                label: 'Read More',
                icon: Icons.arrow_forward,
                onTap: _noAction,
              )
            : null,
        footer = footerPrototype,
        isSkeleton = true;

  /// Whether the card is a skeleton.
  final bool isSkeleton;

  /// The title of the post.
  final String title;

  /// The body of the post.
  final String body;

  /// The action to perform when the title is tapped.
  final VoidCallback? onTitleTap;

  /// The details for the category chip.
  final PostCategoryChipDetails? category;

  /// The details for the "Read More" action.
  final ReadMoreButtonDetails? readMore;

  /// The footer of the card.
  final Widget? footer;

  static void _noAction() {}

  /// The [BorderRadius] for the card.
  static final borderRadius = BorderRadius.circular(AppSpacing.lg);

  /// The border [Color] for the card.
  static const borderColor = Color(0xFFF5F1FF);

  /// The [TextStyle] for the [title].
  static final titleStyle = AppTextStyle.baseTextStyle.copyWith(
    fontSize: 20,
    fontWeight: AppFontWeight.bold,
    height: 1.1,
  );

  /// The [TextStyle] for the [body].
  static final bodyStyle = AppTextStyle.baseTextStyle.copyWith(
    fontSize: 16,
    height: 1.5,
  );

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: isSkeleton | (Skeletonizer.maybeOf(context)?.enabled ?? false),
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        margin: EdgeInsets.zero,
        elevation: 0,
        color: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
          side: const BorderSide(
            color: borderColor,
            // ignore: avoid_redundant_argument_values
            width: AppSpacing.xxxsm,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xlg,
                vertical: AppSpacing.xxlg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (category != null)
                    Padding(
                      padding:
                          const EdgeInsets.only(bottom: AppSpacing.xxxlg / 2),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Skeleton.leaf(
                          child: PostCategoryChip(
                            details: category!,
                          ),
                        ),
                      ),
                    ),
                  GestureDetector(
                    onTap: onTitleTap,
                    child: Text(
                      title,
                      style: titleStyle,
                    ),
                  ),
                  Text(
                    body,
                    style: bodyStyle,
                  ),
                  if (readMore != null)
                    Padding(
                      padding: const EdgeInsets.only(
                        top: AppSpacing.md,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Skeleton.unite(
                          child: ReadMoreButton(
                            details: readMore!,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (footer != null)
              ClipRRect(
                borderRadius: borderRadius,
                child: footer,
              ),
          ],
        ),
      ),
    );
  }
}
