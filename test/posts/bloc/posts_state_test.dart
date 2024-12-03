// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:posts_api/posts_api.dart';
import 'package:posts_app/posts/posts.dart';

void main() {
  group('$PostsBlocState', () {
    test('can be compared', () {
      final state = PostsBlocState(
        posts: const [],
        postsCount: 0,
        isLoading: false,
        error: 'error',
      );
      final same = PostsBlocState(
        posts: const [],
        postsCount: 0,
        isLoading: false,
        error: 'error',
      );
      final other = PostsBlocState.initial();
      expect(state, same);
      expect(state, isNot(other));
    });

    test('can be copied', () {
      final state = PostsBlocState(
        posts: const [],
        postsCount: 0,
        isLoading: false,
        error: 'error',
      );
      final copy1 = state.copyWith(
        posts: () => [
          Post(
            id: 1,
            title: 'title',
            body: 'body',
            category: PostCategory.events,
            image: ImageData(
              url: 'url',
              width: 1,
              height: 1,
            ),
          ),
        ],
        postsCount: 1,
        isLoading: true,
        error: () => null,
      );
      final expected1 = PostsBlocState(
        posts: const [
          Post(
            id: 1,
            title: 'title',
            body: 'body',
            category: PostCategory.events,
            image: ImageData(
              url: 'url',
              width: 1,
              height: 1,
            ),
          ),
        ],
        postsCount: 1,
        isLoading: true,
        error: null,
      );
      expect(copy1, expected1);
      final copy2 = copy1.copyWith(
        posts: () => [],
        error: () => 'error',
      );
      final expected2 = PostsBlocState(
        posts: const [],
        postsCount: 1,
        isLoading: true,
        error: 'error',
      );
      expect(copy2, expected2);
    });
  });
}
