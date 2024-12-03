import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as path;
import 'package:posts_api/posts_api.dart';
import 'package:posts_app/app/app.dart';
import 'package:posts_app/config/config.dart';
import 'package:posts_app/home/home.dart';
import 'package:posts_app/posts/posts.dart';
import 'package:posts_app/routing/routing.dart';

import '../helpers/helpers.dart';

void main() {
  group('$AppRouter', () {
    testWidgets('is adaptive', (tester) async {
      final router = AppRouter();
      addTearDown(router.dispose);
      expect(router.defaultRouteType, isA<AdaptiveRouteType>());
    });

    testWidgets(
        'the ["/"] path displays the $RootWrapper, the $HomePage, and the $PostsTabView',
        (tester) async {
      await tester.pumpAppWithRouter(
        configBuilder: (router) => router.config(
          deepLinkBuilder: (_) => DeepLink.path(
            path.joinAll([
              '/',
            ]),
          ),
        ),
        repositoryProviders: [
          RepositoryProvider<LocalAppConfig>(
            create: (_) => const LocalAppConfig(
              postsPageSize: 25,
              defaultPostImageAspectRatio: 4,
            ),
          ),
          RepositoryProvider<PostsApi>(
            create: (_) => MockPostsApi(),
          ),
        ],
      );
      await tester.pumpAndSettle();
      expect(find.byType(RootWrapper), findsOneWidget);
      expect(find.byType(HomePage), findsOneWidget);
      expect(find.byType(PostsTabView), findsOneWidget);
    });

    testWidgets(
        'the ["/", ""] path displays the $RootWrapper, the $HomePage, and the $PostsTabView',
        (tester) async {
      await tester.pumpAppWithRouter(
        configBuilder: (router) => router.config(
          deepLinkBuilder: (_) => DeepLink.path(
            path.joinAll([
              '/',
              '',
            ]),
          ),
        ),
        repositoryProviders: [
          RepositoryProvider<LocalAppConfig>(
            create: (_) => const LocalAppConfig(
              postsPageSize: 25,
              defaultPostImageAspectRatio: 4,
            ),
          ),
          RepositoryProvider<PostsApi>(
            create: (_) => MockPostsApi(),
          ),
        ],
      );
      await tester.pumpAndSettle();
      expect(find.byType(RootWrapper), findsOneWidget);
      expect(find.byType(HomePage), findsOneWidget);
      expect(find.byType(PostsTabView), findsOneWidget);
    });

    testWidgets(
        'the ["/", "", ""] path displays the $RootWrapper, the $HomePage, and the $PostsTabView',
        (tester) async {
      await tester.pumpAppWithRouter(
        configBuilder: (router) => router.config(
          deepLinkBuilder: (_) => DeepLink.path(
            path.joinAll([
              '/',
              '',
              'posts',
            ]),
          ),
        ),
        repositoryProviders: [
          RepositoryProvider<LocalAppConfig>(
            create: (_) => const LocalAppConfig(
              postsPageSize: 25,
              defaultPostImageAspectRatio: 4,
            ),
          ),
          RepositoryProvider<PostsApi>(
            create: (_) => MockPostsApi(),
          ),
        ],
      );
      await tester.pumpAndSettle();
      expect(find.byType(RootWrapper), findsOneWidget);
      expect(find.byType(HomePage), findsOneWidget);
      expect(find.byType(PostsTabView), findsOneWidget);
    });

    testWidgets(
        'the ["/", "", "posts"] path displays the $RootWrapper, the $HomePage, and the $PostsTabView',
        (tester) async {
      await tester.pumpAppWithRouter(
        configBuilder: (router) => router.config(
          deepLinkBuilder: (_) => DeepLink.path(
            path.joinAll([
              '/',
              '',
              'posts',
            ]),
          ),
        ),
        repositoryProviders: [
          RepositoryProvider<LocalAppConfig>(
            create: (_) => const LocalAppConfig(
              postsPageSize: 25,
              defaultPostImageAspectRatio: 4,
            ),
          ),
          RepositoryProvider<PostsApi>(
            create: (_) => MockPostsApi(),
          ),
        ],
      );
      await tester.pumpAndSettle();
      expect(find.byType(RootWrapper), findsOneWidget);
      expect(find.byType(HomePage), findsOneWidget);
      expect(find.byType(PostsTabView), findsOneWidget);
    });

    testWidgets(
        'the ["/", "", "fav-posts"] path displays the $RootWrapper, the $HomePage, and the $FavPostsTabView',
        (tester) async {
      await tester.pumpAppWithRouter(
        configBuilder: (router) => router.config(
          deepLinkBuilder: (_) => DeepLink.path(
            path.joinAll([
              '/',
              '',
              'fav-posts',
            ]),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(RootWrapper), findsOneWidget);
      expect(find.byType(HomePage), findsOneWidget);
      expect(find.byType(FavPostsTabView), findsOneWidget);
    });

    testWidgets(
        'the ["/", "", "posts", ":postId"] path displays the $RootWrapper, and the $PostPage',
        (tester) async {
      final postId = Random().nextInt(1000);
      await tester.pumpAppWithRouter(
        configBuilder: (router) => router.config(
          deepLinkBuilder: (_) => DeepLink.path(
            path.joinAll([
              '/',
              '',
              'posts',
              '$postId',
            ]),
          ),
        ),
        repositoryProviders: [
          RepositoryProvider<LocalAppConfig>(
            create: (_) => const LocalAppConfig(
              postsPageSize: 25,
              defaultPostImageAspectRatio: 4,
            ),
          ),
          RepositoryProvider<PostsApi>(
            create: (_) => MockPostsApi(),
          ),
        ],
      );
      await tester.pumpAndSettle();
      expect(find.byType(RootWrapper), findsOneWidget);
      expect(find.byType(PostPage), findsOneWidget);
    });
  });
}
