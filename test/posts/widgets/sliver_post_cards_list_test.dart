import 'package:app_ui/app_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:posts_api/posts_api.dart';
import 'package:posts_app/config/config.dart';
import 'package:posts_app/posts/posts.dart';

import '../../helpers/helpers.dart';

void main() {
  group('$SliverPostCardsList', () {
    testWidgets('renders a skeleton variant', (tester) async {
      await tester.pumpAppWithSlivers([
        RepositoryProvider(
          create: (context) => const LocalAppConfig(
            postsPageSize: 50,
            defaultPostImageAspectRatio: 1,
          ),
          child: const SliverPostCardsList.skeleton(postsCount: 3),
        ),
      ]);
      expect(find.byType(SkeletonFullPostCard), findsWidgets);
    });

    testWidgets('renders posts list', (tester) async {
      await tester.runAsync(() async {
        final imagesCacheManager = FakeCacheManager.generic();
        var tapped = false;
        final posts = List.generate(
          3,
          (index) => Post(
            id: index,
            title: 'title $index',
            body: 'body $index',
            category: PostCategory.announcements,
            image: const ImageData(
              url: 'url',
              width: 1,
              height: 1,
            ),
          ),
        );
        await tester.pumpAppWithSlivers([
          InheritedImagesCacheManager(
            cacheManager: imagesCacheManager,
            child: SliverPostCardsList(
              posts: posts,
              onPostSelected: (_) {
                tapped = true;
              },
            ),
          ),
        ]);
        await tester.precacheImagesAndSettle();
        expect(find.byType(AvailableFullPostCard), findsWidgets);
        await tester.tap(find.text('title 0'));
        expect(tapped, isTrue);
      });
    });
  });
}
