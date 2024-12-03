// ignore_for_file: prefer_const_constructors

import 'package:posts_api/posts_api.dart';
import 'package:test/test.dart';

void main() {
  group('$PostsPage', () {
    test('can be instantiated', () {
      const postsPage = PostsPage(
        posts: [
          Post(
            id: 1,
            title: 'title',
            body: 'body',
            category: PostCategory.announcements,
            image: ImageData(
              url: 'url',
              width: 100,
              height: 200,
            ),
          ),
          Post(
            id: 2,
            title: 'title',
            body: 'body',
            category: PostCategory.announcements,
            image: ImageData(
              url: 'url',
              width: 100,
              height: 200,
            ),
          ),
        ],
        postsCount: 2,
      );
      expect(
        postsPage,
        isA<PostsPage>()
            .having(
              (postsPage) => postsPage.posts,
              'posts',
              isA<List<Post>>().having(
                (posts) => posts.length,
                'length',
                2,
              ),
            )
            .having(
              (postsPage) => postsPage.postsCount,
              'postsCount',
              2,
            ),
      );
    });

    test('can be compared', () {
      final page = PostsPage(
        posts: const [
          Post(
            id: 1,
            title: 'title',
            body: 'body',
            category: PostCategory.announcements,
            image: ImageData(
              url: 'url',
              width: 100,
              height: 200,
            ),
          ),
          Post(
            id: 2,
            title: 'title',
            body: 'body',
            category: PostCategory.announcements,
            image: ImageData(
              url: 'url',
              width: 100,
              height: 200,
            ),
          ),
        ],
        postsCount: 2,
      );
      final same = PostsPage(
        posts: const [
          Post(
            id: 1,
            title: 'title',
            body: 'body',
            category: PostCategory.announcements,
            image: ImageData(
              url: 'url',
              width: 100,
              height: 200,
            ),
          ),
          Post(
            id: 2,
            title: 'title',
            body: 'body',
            category: PostCategory.announcements,
            image: ImageData(
              url: 'url',
              width: 100,
              height: 200,
            ),
          ),
        ],
        postsCount: 2,
      );
      final other = PostsPage(
        posts: const [
          Post(
            id: 3,
            title: 'title',
            body: 'body',
            category: PostCategory.announcements,
            image: ImageData(
              url: 'url',
              width: 100,
              height: 200,
            ),
          ),
          Post(
            id: 4,
            title: 'title',
            body: 'body',
            category: PostCategory.announcements,
            image: ImageData(
              url: 'url',
              width: 100,
              height: 200,
            ),
          ),
        ],
        postsCount: 2,
      );
      expect(page, same);
      expect(page, isNot(other));
    });
  });
}
