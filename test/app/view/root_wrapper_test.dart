import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:posts_app/app/app.dart';
import 'package:posts_app/routing/routing.dart';

import '../../helpers/helpers.dart';

void main() {
  group('$RootWrapper', () {
    testWidgets('renders the inner route content', (tester) async {
      final router = AppRouter(
        testRoutes: [
          AdaptiveRoute<void>(
            initial: true,
            page: PageInfo(
              'OuterRoute',
              builder: (_) => const RootWrapper(),
            ),
            children: [
              AdaptiveRoute<void>(
                initial: true,
                page: PageInfo(
                  'InnerRoute',
                  builder: (_) => const Text('InnerRoute'),
                ),
              ),
            ],
          ),
        ],
      );
      addTearDown(router.dispose);
      await tester.pumpAppWithRouter(appRouter: router);
      await tester.pumpAndSettle();
      final outerFinder = find.byType(RootWrapper);
      expect(outerFinder, findsOneWidget);
      final innerFinder = find.descendant(
        of: outerFinder,
        matching: find.text('InnerRoute'),
      );
      expect(innerFinder, findsOneWidget);
    });
  });
}
