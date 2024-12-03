import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:posts_api/posts_api.dart';
import 'package:posts_app/config/config.dart';
import 'package:posts_app/posts/posts.dart';

import '../../helpers/helpers.dart';

void main() {
  group('$FullPostCard', () {
    testWidgets('renders $AvailableFullPostCard', (tester) async {
      const post = Post(
        id: 1,
        title: 'title',
        body: 'body',
        category: PostCategory.business,
        image: ImageData(
          url: 'url',
          width: 1,
          height: 1,
        ),
      );
      await tester.pumpApp(
        const SingleChildScrollView(
          child: FullPostCard(
            post: post,
          ),
        ),
      );
      expect(find.byType(AvailableFullPostCard), findsOneWidget);
    });
  });

  group('${FullPostCard.skeleton}', () {
    testWidgets('renders $SkeletonFullPostCard', (tester) async {
      await tester.pumpApp(
        RepositoryProvider<LocalAppConfig>(
          create: (context) => const LocalAppConfig(
            postsPageSize: 50,
            defaultPostImageAspectRatio: 3.5,
          ),
          child: const FullPostCard.skeleton(),
        ),
      );
      expect(find.byType(SkeletonFullPostCard), findsOneWidget);
    });
  });

  group('$AvailableFullPostCard', () {
    testWidgets('renders a $PostCard with full data', (tester) async {
      const post = Post(
        id: 1,
        title: 'title',
        body: 'body',
        category: PostCategory.flutterNews,
        image: ImageData(
          url: 'url',
          width: 1,
          height: 1,
        ),
      );
      await tester.pumpApp(
        SingleChildScrollView(
          child: AvailableFullPostCard(
            post: post,
            onSelected: () {},
          ),
        ),
      );
      final finder = find.byWidgetPredicate(
        (widget) {
          if (widget is! PostCard) return false;
          return widget.title == post.title &&
              widget.body == post.body &&
              widget.onTitleTap != null &&
              widget.category is PostCategoryChipDetails &&
              widget.readMore is ReadMoreButtonDetails &&
              widget.footer is PostImage;
        },
      );
      expect(finder, findsOneWidget);
    });
  });

  group('$SkeletonFullPostCard', () {
    testWidgets('renders a ${PostCard.skeleton}', (tester) async {
      await tester.pumpApp(
        RepositoryProvider<LocalAppConfig>(
          create: (context) => const LocalAppConfig(
            postsPageSize: 50,
            defaultPostImageAspectRatio: 3.5,
          ),
          // ignore: prefer_const_constructors
          child: SkeletonFullPostCard(),
        ),
      );
      final finder = find.byWidgetPredicate(
        (widget) {
          if (widget is! PostCard) return false;
          return widget.onTitleTap != null &&
              widget.category != null &&
              widget.readMore != null &&
              widget.footer is SkeletonPostImage &&
              widget.isSkeleton;
        },
      );
      expect(finder, findsOneWidget);
    });
  });
}
