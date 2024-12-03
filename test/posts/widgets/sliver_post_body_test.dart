import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:posts_api/posts_api.dart';
import 'package:posts_app/posts/posts.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../helpers/helpers.dart';

void main() {
  group('$SliverPostBody', () {
    testWidgets('displays a skeleton body while loading', (tester) async {
      final postBloc = MockPostBloc();
      when(() => postBloc.state).thenReturn(const PostBlocStateLoading());
      await tester.pumpAppWithSlivers(
        [
          const SliverPostBody(),
        ],
        blocProviders: [
          BlocProvider<PostBloc>.value(
            value: postBloc,
          ),
        ],
      );
      final bodyFinder = find.text(SliverPostBody.bodyPlaceholder);
      expect(bodyFinder, findsOneWidget);
      final bodyContext = tester.firstElement(bodyFinder);
      expect(Skeletonizer.of(bodyContext).enabled, isTrue);
    });

    testWidgets('displays a generic error message when an error occurs',
        (tester) async {
      final postBloc = MockPostBloc();
      when(() => postBloc.state).thenReturn(const PostBlocStateError('error'));
      await tester.pumpAppWithSlivers(
        [
          const SliverPostBody(),
        ],
        blocProviders: [
          BlocProvider<PostBloc>.value(
            value: postBloc,
          ),
        ],
      );
      final bodyFinder = find.text('Unexpected error');
      expect(bodyFinder, findsOneWidget);
      final bodyContext = tester.firstElement(bodyFinder);
      expect(Skeletonizer.of(bodyContext).enabled, isFalse);
    });

    testWidgets('displays an proper message when an unexpected failure occurs',
        (tester) async {
      final postBloc = MockPostBloc();
      when(() => postBloc.state).thenReturn(
        const PostBlocStateError(
          GetPostByIdFailureUnexpected(
            postId: 1,
            error: 'error',
          ),
        ),
      );
      await tester.pumpAppWithSlivers(
        [
          const SliverPostBody(),
        ],
        blocProviders: [
          BlocProvider<PostBloc>.value(
            value: postBloc,
          ),
        ],
      );
      final bodyFinder = find.text('Unexpected failure');
      expect(bodyFinder, findsOneWidget);
      final bodyContext = tester.firstElement(bodyFinder);
      expect(Skeletonizer.of(bodyContext).enabled, isFalse);
    });
  });

  testWidgets('displays a proper message when a post is not found',
      (tester) async {
    final postBloc = MockPostBloc();
    when(() => postBloc.state).thenReturn(
      const PostBlocStateError(
        GetPostByIdFailureNotFound(postId: 1),
      ),
    );
    await tester.pumpAppWithSlivers(
      [
        const SliverPostBody(),
      ],
      blocProviders: [
        BlocProvider<PostBloc>.value(
          value: postBloc,
        ),
      ],
    );
    final bodyFinder = find.text('Post not found');
    expect(bodyFinder, findsOneWidget);
    final bodyContext = tester.firstElement(bodyFinder);
    expect(Skeletonizer.of(bodyContext).enabled, isFalse);
  });

  testWidgets('displays the post body when loaded', (tester) async {
    final postBloc = MockPostBloc();
    when(() => postBloc.state).thenReturn(
      const PostBlocStateLoaded(
        Post(
          id: 1,
          title: 'post - title',
          body: 'body',
          category: PostCategory.flutterNews,
          image: ImageData(
            url: 'url',
            width: 1,
            height: 1,
          ),
        ),
      ),
    );
    await tester.pumpAppWithSlivers(
      [
        const SliverPostBody(),
      ],
      blocProviders: [
        BlocProvider<PostBloc>.value(
          value: postBloc,
        ),
      ],
    );
    final bodyFinder = find.text('body');
    expect(bodyFinder, findsOneWidget);
    final bodyContext = tester.firstElement(bodyFinder);
    expect(Skeletonizer.of(bodyContext).enabled, isFalse);
  });
}
