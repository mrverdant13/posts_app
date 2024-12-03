// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i6;
import 'package:flutter/material.dart' as _i8;
import 'package:posts_api/posts_api.dart' as _i7;
import 'package:posts_app/app/view/root_wrapper.dart' as _i3;
import 'package:posts_app/home/view/home_page.dart' as _i1;
import 'package:posts_app/posts/view/fav_posts_tab_view.dart' as _i4;
import 'package:posts_app/posts/view/post_page.dart' as _i2;
import 'package:posts_app/posts/view/posts_tab_view.dart' as _i5;

/// generated route for
/// [_i1.HomePage]
class HomeRoute extends _i6.PageRouteInfo<void> {
  const HomeRoute({List<_i6.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i1.HomePage();
    },
  );
}

/// generated route for
/// [_i2.PostPage]
class PostRoute extends _i6.PageRouteInfo<PostRouteArgs> {
  PostRoute({
    required int postId,
    _i7.Post? post,
    _i8.Key? key,
    List<_i6.PageRouteInfo>? children,
  }) : super(
          PostRoute.name,
          args: PostRouteArgs(
            postId: postId,
            post: post,
            key: key,
          ),
          rawPathParams: {'postId': postId},
          initialChildren: children,
        );

  static const String name = 'PostRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<PostRouteArgs>(
          orElse: () => PostRouteArgs(postId: pathParams.getInt('postId')));
      return _i2.PostPage(
        postId: args.postId,
        post: args.post,
        key: args.key,
      );
    },
  );
}

class PostRouteArgs {
  const PostRouteArgs({
    required this.postId,
    this.post,
    this.key,
  });

  final int postId;

  final _i7.Post? post;

  final _i8.Key? key;

  @override
  String toString() {
    return 'PostRouteArgs{postId: $postId, post: $post, key: $key}';
  }
}

/// generated route for
/// [_i3.RootWrapper]
class RootWrapperRoute extends _i6.PageRouteInfo<void> {
  const RootWrapperRoute({List<_i6.PageRouteInfo>? children})
      : super(
          RootWrapperRoute.name,
          initialChildren: children,
        );

  static const String name = 'RootWrapperRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i3.RootWrapper();
    },
  );
}

/// generated route for
/// [_i4.FavPostsTabView]
class FavPostsRoute extends _i6.PageRouteInfo<void> {
  const FavPostsRoute({List<_i6.PageRouteInfo>? children})
      : super(
          FavPostsRoute.name,
          initialChildren: children,
        );

  static const String name = 'FavPostsRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i4.FavPostsTabView();
    },
  );
}

/// generated route for
/// [_i5.PostsTabView]
class PostsRoute extends _i6.PageRouteInfo<void> {
  const PostsRoute({List<_i6.PageRouteInfo>? children})
      : super(
          PostsRoute.name,
          initialChildren: children,
        );

  static const String name = 'PostsRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i5.PostsTabView();
    },
  );
}
