import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:posts_api/posts_api.dart';
import 'package:posts_app/posts/posts.dart';

import '../../helpers/mocks/mocks.dart';

void main() {
  group('$PostBloc', () {
    late PostsApi postsApi;
    late PostBloc postBloc;

    setUp(() {
      postsApi = MockPostsApi();
      postBloc = PostBloc(postsApi: postsApi);
    });

    test('initial state is $PostBlocStateInitial', () {
      expect(postBloc.state, const PostBlocStateInitial());
    });

    group('on $PostSet', () {
      blocTest<PostBloc, PostBlocState>(
        'emits [$PostBlocStateLoaded]',
        build: () => postBloc,
        act: (bloc) => bloc.add(
          const PostSet(
            post: Post(
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
        ),
        expect: () => <PostBlocState>[
          const PostBlocStateLoaded(
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
        ],
      );
    });

    group('on $PostRequested', () {
      blocTest<PostBloc, PostBlocState>(
        'emits [$PostBlocStateLoading, $PostBlocStateLoaded] when it succeeds',
        setUp: () {
          when(
            () => postsApi.getPostById(any()),
          ).thenAnswer(
            (_) async => const Post(
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
          );
        },
        build: () => postBloc,
        act: (bloc) => bloc.add(
          const PostRequested(
            postId: 1,
          ),
        ),
        expect: () => <PostBlocState>[
          const PostBlocStateLoading(),
          const PostBlocStateLoaded(
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
        ],
        verify: (bloc) {
          verify(() => postsApi.getPostById(1)).called(1);
        },
      );

      blocTest<PostBloc, PostBlocState>(
        'emits [$PostBlocStateLoading, $PostBlocStateError] when it fails',
        setUp: () {
          when(() => postsApi.getPostById(any())).thenThrow('oops');
        },
        build: () => postBloc,
        act: (bloc) => bloc.add(
          const PostRequested(
            postId: 1,
          ),
        ),
        expect: () => <PostBlocState>[
          const PostBlocStateLoading(),
          const PostBlocStateError('oops'),
        ],
        verify: (bloc) {
          verify(() => postsApi.getPostById(1)).called(1);
        },
      );
    });
  });
}
