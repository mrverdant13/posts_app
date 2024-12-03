// ignore_for_file: prefer_const_declarations

import 'package:flutter_test/flutter_test.dart';
import 'package:posts_api/posts_api.dart';
import 'package:posts_app/posts/posts.dart';

void main() {
  group('$PostBlocEvent', () {
    group('$PostSet', () {
      test('can be instantiated', () {
        const post = Post(
          id: 1,
          title: 'title',
          body: 'body',
          category: PostCategory.events,
          image: ImageData(
            url: 'url',
            width: 1,
            height: 1,
          ),
        );
        expect(
          const PostSet(post: post),
          isA<PostBlocEvent>(),
        );
      });

      test('can be compared', () {
        const post = Post(
          id: 1,
          title: 'title',
          body: 'body',
          category: PostCategory.events,
          image: ImageData(
            url: 'url',
            width: 1,
            height: 1,
          ),
        );
        final event = const PostSet(post: post);
        final same = const PostSet(post: post);
        final other = const PostSet(
          post: Post(
            id: 2,
            title: 'title',
            body: 'body',
            category: PostCategory.events,
            image: ImageData(
              url: 'url',
              width: 1,
              height: 1,
            ),
          ),
        );
        expect(event, same);
        expect(event, isNot(other));
      });
    });

    group('$PostRequested', () {
      test('can be instantiated', () {
        expect(
          const PostRequested(postId: 1),
          isA<PostBlocEvent>(),
        );
      });

      test('can be compared', () {
        final event = const PostRequested(postId: 1);
        final same = const PostRequested(postId: 1);
        final other = const PostRequested(postId: 2);
        expect(event, same);
        expect(event, isNot(other));
      });
    });
  });
}
