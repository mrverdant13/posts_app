// ignore_for_file: prefer_const_constructors

import 'package:posts_api/posts_api.dart';
import 'package:test/test.dart';

void main() {
  group('$Post', () {
    test('can be instantiated', () {
      const failure = Post(
        id: 1,
        title: 'title',
        body: 'body',
        category: PostCategory.announcements,
        image: ImageData(
          url: 'url',
          width: 100,
          height: 200,
        ),
      );
      expect(
        failure,
        isA<Post>()
            .having(
              (failure) => failure.id,
              'id',
              1,
            )
            .having(
              (failure) => failure.title,
              'title',
              'title',
            )
            .having(
              (failure) => failure.body,
              'body',
              'body',
            )
            .having(
              (failure) => failure.category,
              'category',
              PostCategory.announcements,
            )
            .having(
              (failure) => failure.image,
              'image',
              isA<ImageData>()
                  .having(
                    (failure) => failure.url,
                    'url',
                    'url',
                  )
                  .having(
                    (failure) => failure.width,
                    'width',
                    100,
                  )
                  .having(
                    (failure) => failure.height,
                    'height',
                    200,
                  ),
            ),
      );
    });

    test('can be created from JSON', () {
      final post = Post.fromJsonWithBuilders(
        json: const {
          'id': 1,
          'title': 'title',
          'body': 'body',
        },
        imageBuilder: ({required postId}) => const ImageData(
          url: 'url',
          width: 100,
          height: 200,
        ),
        categoryBuilder: ({required postId}) => PostCategory.announcements,
      );
      expect(
        post,
        isA<Post>()
            .having(
              (post) => post.id,
              'id',
              1,
            )
            .having(
              (post) => post.title,
              'title',
              'title',
            )
            .having(
              (post) => post.body,
              'body',
              'body',
            )
            .having(
              (post) => post.category,
              'category',
              PostCategory.announcements,
            )
            .having(
              (post) => post.image,
              'image',
              isA<ImageData>()
                  .having(
                    (post) => post.url,
                    'url',
                    'url',
                  )
                  .having(
                    (post) => post.width,
                    'width',
                    100,
                  )
                  .having(
                    (post) => post.height,
                    'height',
                    200,
                  ),
            ),
      );
    });

    test('can be compared', () {
      final failure = Post(
        id: 1,
        title: 'title',
        body: 'body',
        category: PostCategory.announcements,
        image: const ImageData(
          url: 'url',
          width: 100,
          height: 200,
        ),
      );
      final same = Post(
        id: 1,
        title: 'title',
        body: 'body',
        category: PostCategory.announcements,
        image: const ImageData(
          url: 'url',
          width: 100,
          height: 200,
        ),
      );
      final other = Post(
        id: 2,
        title: 'title',
        body: 'body',
        category: PostCategory.announcements,
        image: const ImageData(
          url: 'url',
          width: 100,
          height: 200,
        ),
      );
      expect(failure, same);
      expect(failure, isNot(other));
    });
  });
}
