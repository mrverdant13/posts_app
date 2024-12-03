// ignore_for_file: prefer_const_constructors

import 'package:posts_api/posts_api.dart';
import 'package:test/test.dart';

void main() {
  group('$GetPostByIdFailure', () {
    group('$GetPostByIdFailureUnexpected', () {
      test('can be instantiated', () {
        const failure = GetPostByIdFailureUnexpected(postId: 1, error: 'error');
        expect(failure, isA<GetPostByIdFailure>());
        expect(
          failure,
          isA<GetPostByIdFailureUnexpected>()
              .having(
                (failure) => failure.postId,
                'postId',
                1,
              )
              .having(
                (failure) => failure.error,
                'error',
                'error',
              ),
        );
      });

      test('can be compared', () {
        final failure = GetPostByIdFailureUnexpected(postId: 1, error: 'error');
        final same = GetPostByIdFailureUnexpected(postId: 1, error: 'error');
        final other = GetPostByIdFailureUnexpected(postId: 2, error: 'error');
        expect(failure, same);
        expect(failure, isNot(other));
      });
    });

    group('$GetPostByIdFailureNotFound', () {
      test('can be instantiated', () {
        const failure = GetPostByIdFailureNotFound(postId: 1);
        expect(failure, isA<GetPostByIdFailure>());
        expect(
          failure,
          isA<GetPostByIdFailureNotFound>().having(
            (failure) => failure.postId,
            'postId',
            1,
          ),
        );
      });

      test('can be compared', () {
        final failure = GetPostByIdFailureNotFound(postId: 1);
        final same = GetPostByIdFailureNotFound(postId: 1);
        expect(failure, same);
        final other = GetPostByIdFailureNotFound(postId: 2);
        expect(failure, same);
        expect(failure, isNot(other));
      });
    });
  });
}
