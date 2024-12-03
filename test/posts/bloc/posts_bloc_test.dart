// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:posts_api/posts_api.dart';
import 'package:posts_app/config/config.dart';
import 'package:posts_app/posts/posts.dart';

import '../../helpers/helpers.dart';

void main() {
  setUpAll(registerFallbackValues);

  group('$PostsBloc', () {
    late LocalAppConfig localAppConfig;
    late PostsApi postsApi;
    late PostsBloc postsBloc;

    setUp(() {
      localAppConfig = MockLocalAppConfig();
      postsApi = MockPostsApi();
      postsBloc = PostsBloc(
        localAppConfig: localAppConfig,
        postsApi: postsApi,
      );
    });

    tearDown(() {
      postsBloc.close();
    });

    test('initial state is ${PostsBlocState.initial()}', () {
      expect(postsBloc.state, PostsBlocState.initial());
    });

    group('on $PostsRequested', () {
      blocTest<PostsBloc, PostsBlocState>(
        'emits [$PostsBlocState(loading: true, error: null), '
        '$PostsBlocState(loading: false, error: not-null)] '
        'when it fails',
        setUp: () {
          when(() => localAppConfig.postsPageSize).thenReturn(5);
          when(
            () => postsApi.getPostsPage(
              offset: any(named: 'offset'),
              limit: any(named: 'limit'),
            ),
          ).thenThrow('some error');
        },
        build: () => postsBloc,
        act: (bloc) => bloc.add(PostsRequested()),
        expect: () => [
          isA<PostsBlocState>()
              .having(
                (s) => s.isLoading,
                'isLoading',
                true,
              )
              .having(
                (s) => s.error,
                'error',
                isNull,
              ),
          isA<PostsBlocState>()
              .having(
                (s) => s.isLoading,
                'isLoading',
                false,
              )
              .having(
                (s) => s.error,
                'error',
                'some error',
              ),
        ],
        verify: (bloc) {
          verify(() => localAppConfig.postsPageSize).called(1);
          verify(() => postsApi.getPostsPage(offset: 0, limit: 5)).called(1);
        },
      );

      blocTest<PostsBloc, PostsBlocState>(
        'emits [$PostsBlocState(loading: true, error: null), '
        '$PostsBlocState(loading: false, error: null, posts: [Post], '
        'postsCount)] when it succeeds',
        setUp: () {
          when(() => localAppConfig.postsPageSize).thenReturn(9);
          when(
            () => postsApi.getPostsPage(
              offset: any(named: 'offset'),
              limit: any(named: 'limit'),
            ),
          ).thenAnswer(
            (_) async => PostsPage(
              posts: const [
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
              ],
              postsCount: 1,
            ),
          );
        },
        build: () => postsBloc,
        act: (bloc) => bloc.add(PostsRequested()),
        expect: () => [
          isA<PostsBlocState>()
              .having(
                (s) => s.isLoading,
                'isLoading',
                isTrue,
              )
              .having(
                (s) => s.error,
                'error',
                isNull,
              ),
          isA<PostsBlocState>()
              .having(
                (s) => s.isLoading,
                'isLoading',
                isFalse,
              )
              .having(
                (s) => s.error,
                'error',
                isNull,
              )
              .having(
            (s) => s.posts,
            'posts',
            const [
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
            ],
          ).having(
            (s) => s.postsCount,
            'postsCount',
            1,
          ),
        ],
        verify: (bloc) {
          verify(() => localAppConfig.postsPageSize).called(1);
          verify(() => postsApi.getPostsPage(offset: 0, limit: 9)).called(1);
        },
      );
    });

    group('on $PostsRefreshed', () {
      blocTest<PostsBloc, PostsBlocState>(
        'emits [${PostsBlocState.initial()}] and adds $PostsRequested',
        setUp: () {
          when(() => localAppConfig.postsPageSize).thenReturn(7);
          when(
            () => postsApi.getPostsPage(
              offset: any(named: 'offset'),
              limit: any(named: 'limit'),
            ),
          ).thenAnswer(
            (_) async => PostsPage(
              posts: const [
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
              ],
              postsCount: 1,
            ),
          );
        },
        build: () => postsBloc,
        act: (bloc) => bloc.add(PostsRefreshed()),
        expect: () => [
          PostsBlocState.initial(),
          isA<PostsBlocState>()
              .having(
                (s) => s.isLoading,
                'isLoading',
                isTrue,
              )
              .having(
                (s) => s.error,
                'error',
                isNull,
              ),
          isA<PostsBlocState>()
              .having(
                (s) => s.isLoading,
                'isLoading',
                isFalse,
              )
              .having(
                (s) => s.error,
                'error',
                isNull,
              )
              .having(
            (s) => s.posts,
            'posts',
            const [
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
            ],
          ).having(
            (s) => s.postsCount,
            'postsCount',
            1,
          ),
        ],
        verify: (bloc) {
          verify(() => localAppConfig.postsPageSize).called(1);
          verify(() => postsApi.getPostsPage(offset: 0, limit: 7)).called(1);
        },
      );
    });
  });
}
