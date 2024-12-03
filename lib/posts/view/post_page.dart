import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posts_api/posts_api.dart';
import 'package:posts_app/posts/posts.dart';

@RoutePage(
  name: 'PostRoute',
)
class PostPage extends StatelessWidget {
  const PostPage({
    @PathParam(PostPage.postIdPathParamKey) required this.postId,
    this.post,
    super.key,
  });

  final int postId;
  final Post? post;

  static const postIdPathParamKey = 'postId';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      key: ValueKey('<app.posts.post-page.post-bloc.$postId>'),
      create: (context) {
        final bloc = PostBloc(
          postsApi: context.read<PostsApi>(),
        );
        switch ((post, postId)) {
          case (final post?, final postId) when post.id == postId:
            bloc.add(PostSet(post: post));
          case _:
            bloc.add(PostRequested(postId: postId));
        }
        return bloc;
      },
      child: const PostView(),
    );
  }
}

@visibleForTesting
class PostView extends StatelessWidget {
  const PostView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPostAppBar(),
          SliverPostImageBanner(),
          SliverPostBody(),
        ],
      ),
    );
  }
}
