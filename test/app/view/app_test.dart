import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:posts_api/posts_api.dart';
import 'package:posts_app/app/app.dart';
import 'package:posts_app/config/config.dart';

import '../../helpers/helpers.dart';

void main() {
  group('$App', () {
    testWidgets(
        'renders a $MaterialApp with a $Router, and displays the $RootWrapper',
        (tester) async {
      const localAppConfig = LocalAppConfig(
        postsPageSize: 25,
        defaultPostImageAspectRatio: 4,
      );
      final postsApi = MockPostsApi();
      await tester.pumpWidget(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider<LocalAppConfig>.value(
              value: localAppConfig,
            ),
            RepositoryProvider<PostsApi>.value(
              value: postsApi,
            ),
          ],
          child: const App(),
        ),
      );
      await tester.pumpAndSettle();
      final appFinder = find.byType(MaterialApp);
      expect(appFinder, findsOneWidget);
      final routerFinder = find.descendant(
        of: appFinder,
        matching: find.byType(Router<Object>),
      );
      expect(routerFinder, findsOneWidget);
      final rootWrapperFinder = find.descendant(
        of: routerFinder,
        matching: find.byType(RootWrapper),
      );
      expect(rootWrapperFinder, findsOneWidget);
    });
  });
}
