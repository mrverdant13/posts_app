import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:posts_api/posts_api.dart';
import 'package:posts_app/posts/posts.dart';

class MockPostsApi extends Mock implements PostsApi {}

class MockPostsBloc extends MockBloc<PostsBlocEvent, PostsBlocState>
    implements PostsBloc {}

class MockPostBloc extends MockBloc<PostBlocEvent, PostBlocState>
    implements PostBloc {}
