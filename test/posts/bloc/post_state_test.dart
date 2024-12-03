// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:posts_api/posts_api.dart';
import 'package:posts_app/posts/posts.dart';

void main() {
  group('$PostBlocState', () {
    group('$PostBlocStateInitial', () {
      test('can be instantiated', () {
        expect(
          const PostBlocStateInitial(),
          isA<PostBlocState>(),
        );
      });

      test('can be compared', () {
        final state = PostBlocStateInitial();
        final same = PostBlocStateInitial();
        expect(state, same);
      });
    });

    group('$PostBlocStateLoading', () {
      test('can be instantiated', () {
        expect(
          const PostBlocStateLoading(),
          isA<PostBlocState>(),
        );
      });

      test('can be compared', () {
        final state = PostBlocStateLoading();
        final same = PostBlocStateLoading();
        expect(state, same);
      });
    });

    group('$PostBlocStateError', () {
      test('can be instantiated', () {
        expect(
          PostBlocStateError('error'),
          isA<PostBlocState>(),
        );
      });

      test('can be compared', () {
        final state = PostBlocStateError('error');
        final same = PostBlocStateError('error');
        final other = PostBlocStateError('other');
        expect(state, same);
        expect(state, isNot(other));
      });
    });

    group('$PostBlocStateLoaded', () {
      test('can be instantiated', () {
        expect(
          PostBlocStateLoaded(
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
          ),
          isA<PostBlocState>(),
        );
      });

      test('can be compared', () {
        final post = Post(
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
        final state = PostBlocStateLoaded(post);
        final same = PostBlocStateLoaded(post);
        final other = PostBlocStateLoaded(
          Post(
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
        expect(state, same);
        expect(state, isNot(other));
      });
    });
  });
}
