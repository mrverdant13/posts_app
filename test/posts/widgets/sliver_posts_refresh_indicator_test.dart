import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:posts_app/posts/posts.dart';

import '../../helpers/helpers.dart';

void main() {
  registerFallbackValues();

  group('$SliverPostsRefreshIndicator', () {
    testWidgets('renders $SliverRefreshIndicator and triggers refresh on pull',
        (tester) async {
      final postsBloc = MockPostsBloc();
      final postsBlocStateStreamController = StreamController<PostsBlocState>();
      addTearDown(postsBlocStateStreamController.close);
      whenListen(
        postsBloc,
        postsBlocStateStreamController.stream,
        initialState: const PostsBlocState.initial(),
      );
      when(() => postsBloc.add(any())).thenReturn(null);
      await tester.pumpAppWithSlivers(
        [
          BlocProvider<PostsBloc>.value(
            value: postsBloc,
            child: const SliverPostsRefreshIndicator(),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 5000,
            ),
          ),
        ],
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
      );
      await tester.pumpAndSettle();
      final refreshIndicatorFinder = find.byType(SliverRefreshIndicator);
      expect(refreshIndicatorFinder, findsOneWidget);
      final gesture = await tester.createGesture();
      await tester.pumpAndSettle();
      await gesture.down(const Offset(100, 100));
      await tester.pumpAndSettle();
      await gesture.moveBy(const Offset(0, 50));
      await tester.pumpAndSettle();
      expect(find.text('Pull to refresh'), findsOneWidget);
      await gesture.moveBy(const Offset(0, 150));
      await tester.pumpAndSettle();
      expect(find.text('Release to refresh'), findsOneWidget);
      await gesture.up();

      // Dragging down again to keep inner message.
      // This is required to check the done message.
      await tester.pumpAndSettle();
      await gesture.down(const Offset(100, 100));
      await gesture.moveBy(const Offset(0, 200));

      postsBlocStateStreamController.add(
        const PostsBlocState.initial().copyWith(isLoading: true),
      );
      await tester.pumpAndSettle();
      expect(find.text('Refreshing...'), findsOneWidget);
      postsBlocStateStreamController.add(
        const PostsBlocState.initial().copyWith(isLoading: false),
      );
      await tester.pumpAndSettle();
      expect(find.text('Done!'), findsOneWidget);
      verify(() => postsBloc.add(const PostsRefreshed())).called(1);
    });
  });
}
