import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:posts_api/posts_api.dart';
import 'package:posts_app/posts/posts.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../helpers/helpers.dart';

void main() {
  group('$SliverPostAppBar', () {
    testWidgets('displays a skeleton title while loading', (tester) async {
      final postBloc = MockPostBloc();
      when(() => postBloc.state).thenReturn(const PostBlocStateLoading());
      await tester.pumpAppWithSlivers(
        [
          const SliverPostAppBar(),
        ],
        blocProviders: [
          BlocProvider<PostBloc>.value(
            value: postBloc,
          ),
        ],
      );
      final titleFinder = find.text(SliverPostAppBar.titlePlaceholder);
      expect(titleFinder, findsNWidgets(2));
      final titleContext = tester.firstElement(titleFinder);
      expect(Skeletonizer.of(titleContext).enabled, isTrue);
    });

    testWidgets('displays a generic error message when an error occurs',
        (tester) async {
      final postBloc = MockPostBloc();
      when(() => postBloc.state).thenReturn(const PostBlocStateError('error'));
      await tester.pumpAppWithSlivers(
        [
          const SliverPostAppBar(),
        ],
        blocProviders: [
          BlocProvider<PostBloc>.value(
            value: postBloc,
          ),
        ],
      );
      final titleFinder = find.text('Oops!');
      expect(titleFinder, findsNWidgets(2));
      final titleContext = tester.firstElement(titleFinder);
      expect(Skeletonizer.of(titleContext).enabled, isFalse);
    });

    testWidgets('displays the post title when loaded', (tester) async {
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
          const SliverPostAppBar(),
        ],
        blocProviders: [
          BlocProvider<PostBloc>.value(
            value: postBloc,
          ),
        ],
      );
      final titleFinder = find.text('post - title');
      expect(titleFinder, findsNWidgets(2));
      final titleContext = tester.firstElement(titleFinder);
      expect(Skeletonizer.of(titleContext).enabled, isFalse);
    });
  });
}
