import 'package:app_ui/app_ui.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posts_api/posts_api.dart';
import 'package:posts_app/app/app.dart';
import 'package:posts_app/config/config.dart';
import 'package:posts_app/posts/posts.dart';
import 'package:posts_app/routing/routing.dart';
import 'package:sliver_tools/sliver_tools.dart';

@RoutePage(
  name: 'PostsRoute',
)
class PostsTabView extends StatelessWidget {
  const PostsTabView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final postsUnavailable = context.select(
      (PostsBloc bloc) => bloc.state.posts == null,
    );
    return CustomScrollView(
      key: const PageStorageKey(
        '<app.posts.posts-tab-view.posts-custom-scroll-view>',
      ),
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        const DefaultSliverOverlapInjector(
          key: ValueKey(
            '<app.posts.posts-tab-view.default-sliver-overlap-injector>',
          ),
        ),
        const SliverPostsRefreshIndicator(),
        if (postsUnavailable)
          const SliverNoLoadedPostsList()
        else
          const SliverLoadedPostsList(),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: AppSpacing.xlg,
          ),
        ),
      ],
    );
  }
}

@visibleForTesting
class SliverNoLoadedPostsList extends StatelessWidget {
  const SliverNoLoadedPostsList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final (isLoading, loadError) = context.select(
      (PostsBloc bloc) => (bloc.state.isLoading, bloc.state.error),
    );
    if (isLoading) {
      return SliverPostCardsList.skeleton(
        postsCount: context.postsPageSize,
      );
    }
    if (loadError != null) {
      return SliverFillRemaining(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            GetPostsPageErrorText(error: loadError),
            GenericRetryButton(
              onPressed: () {
                context.read<PostsBloc>().add(const PostsRequested());
              },
            ),
          ],
        ),
      );
    }
    return SliverPostCardsList.skeleton(
      postsCount: context.postsPageSize,
    );
  }
}

@visibleForTesting
class SliverLoadedPostsList extends StatefulWidget {
  const SliverLoadedPostsList({
    super.key,
  });

  @override
  State<SliverLoadedPostsList> createState() => _SliverLoadedPostsListState();
}

class _SliverLoadedPostsListState extends State<SliverLoadedPostsList> {
  ScrollPosition? _scrollPosition;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final scrollPosition = Scrollable.of(context).position;
    if (_scrollPosition != scrollPosition) {
      _scrollPosition?.removeListener(_scrollPositionListener);
      _scrollPosition = scrollPosition;
      _scrollPosition?.addListener(_scrollPositionListener);
    }
  }

  @override
  void dispose() {
    _scrollPosition?.removeListener(_scrollPositionListener);
    super.dispose();
  }

  void _scrollPositionListener() {
    final bloc = context.read<PostsBloc>();
    if (bloc.state.isLoading) return;
    if (bloc.state.error != null) return;
    if (_scrollPosition == null) return;
    final ScrollPosition(:pixels, :maxScrollExtent) = _scrollPosition!;
    final remainingExtent = maxScrollExtent - pixels;
    if (remainingExtent < 200) bloc.add(const PostsRequested());
  }

  void onPostSelected(Post post) {
    PostRoute(
      postId: post.id,
      post: post,
    ).navigate(context);
  }

  @override
  Widget build(BuildContext context) {
    final PostsBlocState(
      :posts,
      :isLoading,
      :error,
    ) = context.watch<PostsBloc>().state;
    return MultiSliver(
      children: [
        if (posts != null)
          SliverPostCardsList(
            posts: posts,
            onPostSelected: onPostSelected,
          ),
        if (isLoading)
          SliverPostCardsList.skeleton(
            postsCount: context.postsPageSize,
          )
        else if (error != null)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(
                top: AppSpacing.lg,
                bottom: AppSpacing.xxxlg,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  GetPostsPageErrorText(error: error),
                  GenericRetryButton(
                    onPressed: () {
                      context.read<PostsBloc>().add(const PostsRequested());
                    },
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
