// ignore_for_file: prefer_const_constructors

import 'package:posts_api/posts_api.dart';
import 'package:test/fake.dart';
import 'package:test/test.dart';

class FakePostsApi extends Fake implements PostsApi {}

void main() {
  test('PostsApi can be implemented', () {
    expect(FakePostsApi.new, returnsNormally);
  });
}
