import 'package:flutter_test/flutter_test.dart';
import 'package:posts_api/posts_api.dart';
import 'package:posts_app/posts/posts.dart';

import '../../helpers/helpers.dart';

void main() {
  group('$GetPostsPageErrorText', () {
    testWidgets('renders generic unexpected error message', (tester) async {
      await tester.pumpApp(
        const GetPostsPageErrorText(
          error: 'error',
        ),
      );
      expect(find.text('Unexpected error'), findsOneWidget);
    });

    testWidgets('renders generic unexpected failure message', (tester) async {
      await tester.pumpApp(
        const GetPostsPageErrorText(
          error: GetPostsPageFailureUnexpected(
            error: 'error',
            offset: 0,
            limit: 0,
          ),
        ),
      );
      expect(find.text('Unexpected failure'), findsOneWidget);
    });
  });
}
