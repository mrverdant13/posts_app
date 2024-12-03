import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:posts_api/posts_api.dart';
import 'package:posts_app/app/app.dart';
import 'package:posts_app/config/config.dart';
import 'package:posts_app/posts/posts.dart';
import 'package:posts_app/routing/routing.dart';

import '../../helpers/helpers.dart';

void main() {
  registerFallbackValues();

  group('$PostsTabView', () {
    late PostsBloc postsBloc;

    setUp(() {
      postsBloc = MockPostsBloc();
    });

    Future<void> pumpSubject(WidgetTester tester) async {
      await tester.pumpAppWithNestedScrollViewBody(
        const PostsTabView(),
        blocProviders: [
          BlocProvider<PostsBloc>.value(
            value: postsBloc,
          ),
        ],
        repositoryProviders: [
          RepositoryProvider<LocalAppConfig>(
            create: (_) => const LocalAppConfig(
              postsPageSize: 50,
              defaultPostImageAspectRatio: 3.5,
            ),
          ),
        ],
      );
    }

    testWidgets(
      'renders a $CustomScrollView with a $SliverPostsRefreshIndicator',
      (tester) async {
        when(() => postsBloc.state).thenReturn(const PostsBlocState.initial());
        await pumpSubject(tester);
        expect(find.byType(CustomScrollView), findsOneWidget);
        expect(find.byType(SliverPostsRefreshIndicator), findsOneWidget);
      },
    );

    testWidgets(
      'renders a $SliverLoadedPostsList when posts are loaded',
      (tester) async {
        when(() => postsBloc.state).thenReturn(
          const PostsBlocState.initial().copyWith(
            postsCount: 50,
            posts: () => List.generate(
              50,
              (index) => Post(
                id: index,
                title: 'title',
                body: 'body',
                category: PostCategory.flutterNews,
                image: const ImageData(
                  url: 'url',
                  width: 1,
                  height: 1,
                ),
              ),
            ),
          ),
        );
        await pumpSubject(tester);
        expect(find.byType(CustomScrollView), findsOneWidget);
        expect(find.byType(SliverLoadedPostsList), findsOneWidget);
      },
    );

    testWidgets('renders a $SliverNoLoadedPostsList when posts are not loaded',
        (tester) async {
      when(() => postsBloc.state).thenReturn(
        const PostsBlocState.initial().copyWith(posts: () => null),
      );
      await pumpSubject(tester);
      expect(find.byType(CustomScrollView), findsOneWidget);
      expect(find.byType(SliverNoLoadedPostsList), findsOneWidget);
    });
  });

  group('$SliverNoLoadedPostsList', () {
    late PostsBloc postsBloc;

    setUp(() {
      postsBloc = MockPostsBloc();
    });

    Future<void> pumpSubject(WidgetTester tester) async {
      await tester.pumpAppWithSlivers(
        [
          const SliverNoLoadedPostsList(),
        ],
        repositoryProviders: [
          RepositoryProvider<LocalAppConfig>(
            create: (_) => const LocalAppConfig(
              postsPageSize: 50,
              defaultPostImageAspectRatio: 3.5,
            ),
          ),
        ],
        blocProviders: [
          BlocProvider<PostsBloc>.value(
            value: postsBloc,
          ),
        ],
      );
    }

    testWidgets(
      'renders a ${SliverPostCardsList.skeleton} when loading',
      (tester) async {
        when(() => postsBloc.state).thenReturn(
          const PostsBlocState.initial().copyWith(isLoading: true),
        );
        await pumpSubject(tester);
        final cardsListFinder = find.byType(SliverPostCardsList);
        expect(cardsListFinder, findsOneWidget);
        final cardsList = tester.widget(cardsListFinder);
        expect(
          cardsList,
          isA<SliverPostCardsList>()
              .having(
                (s) => s.posts,
                'posts',
                isNull,
              )
              .having(
                (s) => s.postsCount,
                'postsCount',
                50,
              ),
        );
      },
    );

    testWidgets(
      'renders a $GetPostsPageErrorText and a $GenericRetryButton when an '
      'error occurs',
      (tester) async {
        when(() => postsBloc.state).thenReturn(
          const PostsBlocState.initial().copyWith(error: () => 'error'),
        );
        when(() => postsBloc.add(any())).thenAnswer((_) {});
        await pumpSubject(tester);
        expect(find.byType(GetPostsPageErrorText), findsOneWidget);
        final buttonFinder = find.byType(GenericRetryButton);
        expect(buttonFinder, findsOneWidget);
        await tester.tap(buttonFinder);
        verify(() => postsBloc.add(const PostsRequested())).called(1);
      },
    );
  });

  group('$SliverLoadedPostsList', () {
    late StackRouter stackRouter;
    late PostsBloc postsBloc;

    setUp(() {
      stackRouter = MockStackRouter();
      postsBloc = MockPostsBloc();
    });

    Future<void> pumpSubject(WidgetTester tester) async {
      final imagesCacheManager = FakeCacheManager.generic();
      await tester.pumpAppWithSlivers(
        [
          StackRouterScope(
            controller: stackRouter,
            stateHash: 0,
            child: InheritedImagesCacheManager(
              cacheManager: imagesCacheManager,
              child: const SliverLoadedPostsList(),
            ),
          ),
        ],
        repositoryProviders: [
          RepositoryProvider<LocalAppConfig>(
            create: (_) => const LocalAppConfig(
              postsPageSize: 50,
              defaultPostImageAspectRatio: 3.5,
            ),
          ),
        ],
        blocProviders: [
          BlocProvider<PostsBloc>.value(
            value: postsBloc,
          ),
        ],
      );
      await tester.precacheImagesAndSettle();
    }

    testWidgets(
      'renders a $SliverPostCardsList with posts and loads more '
      'when reaching the end of the list',
      (tester) async {
        await tester.runAsync(() async {
          final streamController = StreamController<PostsBlocState>();
          addTearDown(streamController.close);
          final state0 = PostsBlocState(
            error: null,
            isLoading: false,
            postsCount: 80,
            posts: List.generate(
              5,
              (index) => Post(
                id: index,
                title: 'title',
                body: 'body',
                category: PostCategory.flutterNews,
                image: const ImageData(
                  url: 'url',
                  width: 1,
                  height: 1,
                ),
              ),
            ),
          );
          whenListen(
            postsBloc,
            streamController.stream,
            initialState: state0,
          );
          final state1 = state0.copyWith(isLoading: true);
          when(() => postsBloc.add(any())).thenAnswer((_) {
            streamController.add(state1);
          });
          await pumpSubject(tester);
          await tester.jumpToBottom();
          await tester.pump();
          verify(() => postsBloc.add(const PostsRequested())).called(1);
          final skeletonListFinder = find.byWidgetPredicate(
            (widget) => widget is SliverPostCardsList && widget.posts == null,
          );
          await tester.scrollUntilVisible(skeletonListFinder, 500);
          final skeletonCardFinder = find.byType(SkeletonFullPostCard);
          expect(skeletonCardFinder, findsWidgets);
        });
      },
    );

    testWidgets(
      'navigates to the $PostRoute when a post is selected',
      (tester) async {
        await tester.runAsync(() async {
          when(() => stackRouter.navigate(any())).thenAnswer((_) async {});
          const post = Post(
            id: 1,
            title: 'post title',
            body: 'body',
            category: PostCategory.flutterNews,
            image: ImageData(
              url: 'url',
              width: 1,
              height: 1,
            ),
          );
          when(() => postsBloc.state).thenReturn(
            const PostsBlocState(
              error: null,
              isLoading: false,
              postsCount: 80,
              posts: [post],
            ),
          );
          await pumpSubject(tester);
          final titleFinder = find.descendant(
            of: find.byType(PostCard),
            matching: find.text('post title'),
          );
          await tester.tap(titleFinder);
          final route = PostRoute(
            postId: post.id,
            post: post,
          );
          verify(() => stackRouter.navigate(route)).called(1);
        });
      },
    );

    testWidgets(
      'renders a $SliverPostCardsList with posts and displays a retry button '
      'when an error occurs',
      (tester) async {
        await tester.runAsync(() async {
          when(() => postsBloc.state).thenReturn(
            PostsBlocState(
              error: 'error',
              isLoading: false,
              postsCount: 80,
              posts: List.generate(
                5,
                (index) => Post(
                  id: index,
                  title: 'title',
                  body: 'body',
                  category: PostCategory.flutterNews,
                  image: const ImageData(
                    url: 'url',
                    width: 1,
                    height: 1,
                  ),
                ),
              ),
            ),
          );
          when(() => postsBloc.add(any())).thenAnswer((_) {});
          await pumpSubject(tester);
          await tester.jumpToBottom();
          await tester.pumpAndSettle();
          final retryButtonFinder = find.byType(GenericRetryButton);
          await tester.scrollUntilVisible(retryButtonFinder, 500);
          await tester.tap(retryButtonFinder);
          verify(() => postsBloc.add(const PostsRequested())).called(1);
        });
      },
    );
  });
}
