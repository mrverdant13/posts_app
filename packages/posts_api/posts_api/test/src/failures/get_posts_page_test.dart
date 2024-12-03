// ignore_for_file: prefer_const_constructors

import 'package:posts_api/posts_api.dart';
import 'package:test/test.dart';

void main() {
  group('$GetPostsPageFailure', () {
    group('$GetPostsPageFailureUnexpected', () {
      test('can be instantiated', () {
        const failure = GetPostsPageFailureUnexpected(
          offset: 0,
          limit: 10,
          error: 'error',
        );

        expect(failure, isA<GetPostsPageFailure>());
        expect(
          failure,
          isA<GetPostsPageFailureUnexpected>()
              .having(
                (failure) => failure.offset,
                'offset',
                0,
              )
              .having(
                (failure) => failure.limit,
                'limit',
                10,
              )
              .having(
                (failure) => failure.error,
                'error',
                'error',
              ),
        );
      });

      test('can be compared', () {
        final failure = GetPostsPageFailureUnexpected(
          offset: 0,
          limit: 10,
          error: 'error',
        );
        final same = GetPostsPageFailureUnexpected(
          offset: 0,
          limit: 10,
          error: 'error',
        );
        final other = GetPostsPageFailureUnexpected(
          offset: 1,
          limit: 10,
          error: 'error',
        );
        expect(failure, same);
        expect(failure, isNot(other));
      });
    });
  });
}
