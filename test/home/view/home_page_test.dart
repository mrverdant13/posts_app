import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:posts_api/posts_api.dart';
import 'package:posts_app/config/config.dart';
import 'package:posts_app/home/home.dart';
import 'package:posts_app/posts/posts.dart';
import 'package:posts_app/routing/routing.dart';

import '../../helpers/helpers.dart';

void main() {
  late LocalAppConfig localAppConfig;
  late PostsApi postsApi;
  late AppRouter router;

  setUp(() {
    localAppConfig = const LocalAppConfig(
      postsPageSize: 25,
      defaultPostImageAspectRatio: 4,
    );
    postsApi = MockPostsApi();
    router = AppRouter(
      testRoutes: [
        AdaptiveRoute<void>(
          initial: true,
          page: PageInfo(
            'OuterRoute',
            builder: (_) => MultiRepositoryProvider(
              providers: [
                RepositoryProvider<LocalAppConfig>.value(
                  value: localAppConfig,
                ),
                RepositoryProvider<PostsApi>.value(
                  value: postsApi,
                ),
              ],
              child: const HomePage(),
            ),
          ),
          children: [
            AdaptiveRoute<void>(
              page: PostsRoute.page,
            ),
            AdaptiveRoute<void>(
              page: FavPostsRoute.page,
            ),
          ],
        ),
      ],
    );
  });

  tearDown(() {
    router.dispose();
  });

  final homeViewFinder = find.byType(HomeView);
  final appBarFinder = find.descendant(
    of: homeViewFinder,
    matching: find.byType(SliverHomeAppBar),
  );
  final tabBarFinder = find.descendant(
    of: appBarFinder,
    matching: find.byType(TabBar),
  );
  final postsTabFinder = find.descendant(
    of: tabBarFinder,
    matching: find.text('Posts'),
  );
  final favsTabFinder = find.descendant(
    of: tabBarFinder,
    matching: find.text('Favs'),
  );

  group('$HomePage', () {
    testWidgets('renders a $HomeView', (tester) async {
      await tester.pumpAppWithRouter(appRouter: router);
      await tester.pumpAndSettle();
      expect(homeViewFinder, findsOneWidget);
    });
  });

  group('$HomeView', () {
    testWidgets('renders a $SliverHomeAppBar with a $TabBar with two tabs',
        (tester) async {
      await tester.pumpAppWithRouter(appRouter: router);
      await tester.pumpAndSettle();
      expect(appBarFinder, findsOneWidget);
      expect(tabBarFinder, findsOneWidget);
      expect(postsTabFinder, findsOneWidget);
      expect(favsTabFinder, findsOneWidget);
    });

    testWidgets(
        'renders a $PostsTabView in the first tab and '
        '$FavPostsTabView in the second tab', (tester) async {
      await tester.pumpAppWithRouter(appRouter: router);
      await tester.pumpAndSettle();
      await tester.tap(favsTabFinder);
      await tester.pumpAndSettle();
      expect(find.byType(FavPostsTabView), findsOneWidget);
      await tester.tap(postsTabFinder);
      await tester.pumpAndSettle();
      expect(find.byType(PostsTabView), findsOneWidget);
    });
  });
}
