// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:posts_app/posts/posts.dart';

void main() {
  group('$PostsBlocEvent', () {
    group('$PostsRequested', () {
      test('can be instantiated', () {
        expect(
          const PostsRequested(),
          isA<PostsBlocEvent>(),
        );
      });

      test('can be compared', () {
        final event = PostsRequested();
        final same = PostsRequested();
        expect(event, same);
      });
    });

    group('$PostsRefreshed', () {
      test('can be instantiated', () {
        expect(
          const PostsRefreshed(),
          isA<PostsBlocEvent>(),
        );
      });

      test('can be compared', () {
        final event = PostsRefreshed();
        final same = PostsRefreshed();
        expect(event, same);
      });
    });
  });
}
