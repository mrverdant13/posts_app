// ignore_for_file: prefer_const_constructors

import 'package:posts_api/posts_api.dart';
import 'package:test/test.dart';

void main() {
  group('$ImageData', () {
    test('can be instantiated', () {
      const failure = ImageData(
        url: 'url',
        width: 100,
        height: 200,
      );
      expect(
        failure,
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
            )
            .having(
              (failure) => failure.aspectRatio,
              'aspectRatio',
              0.5,
            ),
      );
    });

    test('can be compared', () {
      final failure = ImageData(
        url: 'url',
        width: 100,
        height: 200,
      );
      final same = ImageData(
        url: 'url',
        width: 100,
        height: 200,
      );
      final other = ImageData(
        url: 'other',
        width: 100,
        height: 200,
      );
      expect(failure, same);
      expect(failure, isNot(other));
    });
  });
}
