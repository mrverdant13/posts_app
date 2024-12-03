import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:posts_app/app/app.dart';

import '../../helpers/helpers.dart';

void main() {
  group('$GenericRetryButton', () {
    testWidgets('renders a $FilledButton with a generic label', (tester) async {
      await tester.pumpApp(
        GenericRetryButton(
          onPressed: () {},
        ),
      );
      await tester.pumpAndSettle();
      final finder = find.descendant(
        of: find.byType(FilledButton),
        matching: find.text('Retry'),
      );
      expect(finder, findsOneWidget);
    });

    testWidgets('calls onPressed when button is pressed', (tester) async {
      var pressed = false;
      await tester.pumpApp(
        GenericRetryButton(
          onPressed: () => pressed = true,
        ),
      );
      await tester.pumpAndSettle();
      expect(pressed, isFalse);
      await tester.tap(find.byType(GenericRetryButton));
      expect(pressed, isTrue);
    });
  });
}
