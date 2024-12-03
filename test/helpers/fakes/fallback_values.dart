import 'package:mocktail/mocktail.dart';
import 'package:posts_app/posts/posts.dart';

import 'routing.dart';

void registerFallbackValues() {
  registerFallbackValue(const PostsRequested());
  registerFallbackValue(FakePageRouteInfo());
}
