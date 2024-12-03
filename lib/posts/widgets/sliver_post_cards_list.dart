import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:posts_api/posts_api.dart';
import 'package:posts_app/posts/posts.dart';

typedef PostSelectionCallback = void Function(Post post);

class SliverPostCardsList extends StatelessWidget {
  const SliverPostCardsList({
    required List<Post> this.posts,
    required PostSelectionCallback this.onPostSelected,
    super.key,
  }) : postsCount = posts.length;

  const SliverPostCardsList.skeleton({
    required this.postsCount,
    super.key,
  })  : posts = null,
        onPostSelected = null;

  final List<Post>? posts;
  final PostSelectionCallback? onPostSelected;
  final int postsCount;

  static Widget skeletonPostsBuilder(
    BuildContext context,
    int index,
  ) {
    return const FullPostCard.skeleton();
  }

  static Widget postBuilder(
    BuildContext context,
    Post post,
    PostSelectionCallback? onPostSelected,
  ) {
    return FullPostCard(
      post: post,
      onSelected: onPostSelected == null ? null : () => onPostSelected(post),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      sliver: SliverList.separated(
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.lg),
        itemCount: postsCount,
        itemBuilder: switch (posts) {
          null => skeletonPostsBuilder,
          final posts => (context, index) => postBuilder(
                context,
                posts[index],
                onPostSelected,
              ),
        },
      ),
    );
  }
}
