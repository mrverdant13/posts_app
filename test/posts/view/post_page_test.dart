import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:posts_api/posts_api.dart';
import 'package:posts_app/config/config.dart';
import 'package:posts_app/posts/posts.dart';

import '../../helpers/helpers.dart';

void main() {
  group('$PostPage', () {
    testWidgets('renders $PostView', (tester) async {
      await tester.pumpApp(
        const PostPage(
          postId: 1,
        ),
        repositoryProviders: [
          RepositoryProvider<LocalAppConfig>(
            create: (_) => const LocalAppConfig(
              postsPageSize: 50,
              defaultPostImageAspectRatio: 3.5,
            ),
          ),
          RepositoryProvider<PostsApi>(
            create: (_) => MockPostsApi(),
          ),
        ],
      );
      expect(find.byType(PostView), findsOneWidget);
    });

    testWidgets('requests $Post data when not provided', (tester) async {
      final postsApi = MockPostsApi();
      when(() => postsApi.getPostById(any())).thenAnswer(
        (_) => Future.value(
          const Post(
            id: 1,
            title: 'title',
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
      await tester.pumpApp(
        const PostPage(
          postId: 1,
        ),
        repositoryProviders: [
          RepositoryProvider<LocalAppConfig>(
            create: (_) => const LocalAppConfig(
              postsPageSize: 50,
              defaultPostImageAspectRatio: 3.5,
            ),
          ),
          RepositoryProvider<PostsApi>.value(
            value: postsApi,
          ),
        ],
      );
      verify(() => postsApi.getPostById(1)).called(1);
    });

    testWidgets('does not request $Post data when provided', (tester) async {
      final postsApi = MockPostsApi();
      when(() => postsApi.getPostById(any())).thenAnswer(
        (_) => Future.value(
          const Post(
            id: 1,
            title: 'title',
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
      await tester.pumpApp(
        const PostPage(
          postId: 1,
          post: Post(
            id: 1,
            title: 'title',
            body: 'body',
            category: PostCategory.flutterNews,
            image: ImageData(
              url: 'url',
              width: 1,
              height: 1,
            ),
          ),
        ),
        repositoryProviders: [
          RepositoryProvider<LocalAppConfig>(
            create: (_) => const LocalAppConfig(
              postsPageSize: 50,
              defaultPostImageAspectRatio: 3.5,
            ),
          ),
          RepositoryProvider<PostsApi>.value(
            value: postsApi,
          ),
        ],
      );
      verifyNever(() => postsApi.getPostById(1));
    });
  });


}
