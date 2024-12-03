// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:posts_app/config/config.dart';

void main() {
  group('$LocalAppConfig', () {
    test('can be instantiated', () {
      const localAppConfig = LocalAppConfig(
        postsPageSize: 5,
        defaultPostImageAspectRatio: 0.5,
      );
      expect(
        localAppConfig,
        isA<LocalAppConfig>()
            .having(
              (config) => config.postsPageSize,
              'postsPageSize',
              5,
            )
            .having(
              (config) => config.defaultPostImageAspectRatio,
              'defaultPostImageAspectRatio',
              0.5,
            ),
      );
    });

    test('can be compared', () {
      final config = LocalAppConfig(
        postsPageSize: 5,
        defaultPostImageAspectRatio: 0.5,
      );
      final same = LocalAppConfig(
        postsPageSize: 5,
        defaultPostImageAspectRatio: 0.5,
      );
      final other = LocalAppConfig(
        postsPageSize: 10,
        defaultPostImageAspectRatio: 0.5,
      );
      expect(config, same);
      expect(config, isNot(other));
    });
  });
}
