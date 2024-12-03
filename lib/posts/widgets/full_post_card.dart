import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:posts_api/posts_api.dart';
import 'package:posts_app/config/config.dart';
import 'package:posts_app/l10n/l10n.dart';

abstract class FullPostCard extends StatelessWidget {
  const factory FullPostCard({
    required Post post,
    VoidCallback? onSelected,
    Key? key,
  }) = AvailableFullPostCard;

  const factory FullPostCard.skeleton({
    Key? key,
  }) = SkeletonFullPostCard;

  const FullPostCard._({
    super.key,
  });
}

@visibleForTesting
class AvailableFullPostCard extends FullPostCard {
  const AvailableFullPostCard({
    required this.post,
    this.onSelected,
    super.key,
  }) : super._();

  final Post post;
  final VoidCallback? onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final image = post.image;
    return PostCard(
      title: post.title,
      body: post.body,
      onTitleTap: onSelected,
      category: PostCategoryChipDetails(
        label: l10n.postCategoryLabel(post.category.name),
        color: post.category.color,
      ),
      readMore: onSelected == null
          ? null
          : ReadMoreButtonDetails(
              label: l10n.genericReadMoreMessage,
              icon: Icons.adaptive.arrow_forward,
              onTap: onSelected!,
            ),
      footer: PostImage(
        aspectRatio: image.aspectRatio,
        imageUrl: image.url,
        onTap: onSelected,
      ),
    );
  }
}

@visibleForTesting
class SkeletonFullPostCard extends FullPostCard {
  const SkeletonFullPostCard({
    super.key,
  }) : super._();

  @override
  Widget build(BuildContext context) {
    return PostCard.skeleton(
      hasCategory: true,
      hasReadMore: true,
      footerPrototype: PostImage.skeleton(
        aspectRatio: context.defaultPostImageAspectRatio,
      ),
    );
  }
}

extension on PostCategory {
  Color get color => switch (this) {
        PostCategory.technical || PostCategory.announcements => AppColors.lilac,
        PostCategory.events || PostCategory.business => AppColors.teal,
        PostCategory.flutterNews => AppColors.navyBlue,
      };
}
