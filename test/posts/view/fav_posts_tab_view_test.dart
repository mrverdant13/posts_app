import 'package:flutter_test/flutter_test.dart';
import 'package:posts_app/posts/posts.dart';

import '../../helpers/helpers.dart';

void main() {
  group('$FavPostsTabView', () {
    testWidgets('renders a message', (tester) async {
      await tester.pumpApp(const FavPostsTabView());
      expect(find.text('Coming soon!'), findsOneWidget);
    });
  });
}
