import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:dio_posts_api/dio_posts_api.dart';
import 'package:posts_api/posts_api.dart';
import 'package:test/test.dart';

void main() {
  group('$DioPostsApi', () {
    late Dio dio;
    late DioPostsApi dioPostsApi;

    setUp(() {
      dio = Dio();
      dioPostsApi = DioPostsApi(
        dio: dio,
        postsImagesBaseUrl: 'https://example.com',
      );
    });

    test('can be instantiated', () {
      expect(dioPostsApi, isA<PostsApi>());
    });

    test('has an internal random number generator', () {
      expect(DioPostsApi.random, isA<Random>());
    });

    test('can build image URI', () {
      final imageUri = dioPostsApi.buildImageUri(postId: 1);
      expect(imageUri.toString(), 'https://example.com/1/400/150');
    });

    test('can build image data', () {
      final imageData = dioPostsApi.buildImageData(postId: 1);
      expect(
        imageData,
        isA<ImageData>()
            .having(
              (failure) => failure.url,
              'url',
              'https://example.com/1/400/150',
            )
            .having(
              (failure) => failure.width,
              'width',
              400,
            )
            .having(
              (failure) => failure.height,
              'height',
              150,
            ),
      );
    });

    test('can build post category', () {
      final postCategory = dioPostsApi.buildPostCategory(postId: 1);
      expect(postCategory, isA<PostCategory>());
    });

    group('getPostsPage', () {
      test('throws a $GetPostsPageFailureUnexpected on error', () async {
        dio.interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) =>
                throw Exception('Unexpected error'),
          ),
        );
        Future<void> action() => dioPostsApi.getPostsPage(
              offset: 20,
              limit: 10,
            );
        await expectLater(
          action,
          throwsA(
            isA<GetPostsPageFailureUnexpected>()
                .having(
                  (e) => e.offset,
                  'offset',
                  20,
                )
                .having(
                  (e) => e.limit,
                  'limit',
                  10,
                ),
          ),
        );
      });

      test('returns a $PostsPage on success', () async {
        dio.interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) => handler.resolve(
              Response<List<dynamic>>(
                data: List.generate(
                  10,
                  (index) => <String, dynamic>{
                    'id': index + 1,
                    'title': 'Post ${index + 1}',
                    'body': 'Body ${index + 1}',
                  },
                ),
                requestOptions: RequestOptions(),
                headers: Headers.fromMap({
                  'X-Total-Count': ['100'],
                }),
              ),
            ),
          ),
        );
        final postsPage = await dioPostsApi.getPostsPage(
          offset: 20,
          limit: 10,
        );
        expect(
          postsPage,
          isA<PostsPage>()
              .having(
                (page) => page.posts,
                'posts',
                isA<List<Post>>().having(
                  (posts) => posts.length,
                  'length',
                  10,
                ),
              )
              .having(
                (page) => page.postsCount,
                'postsCount',
                100,
              ),
        );
      });
    });

    group('getPostById', () {
      test('throws a $GetPostByIdFailureUnexpected on an unexpected error',
          () async {
        dio.interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) =>
                throw Exception('Unexpected error'),
          ),
        );
        Future<void> action() => dioPostsApi.getPostById(1);
        await expectLater(
          action,
          throwsA(
            isA<GetPostByIdFailureUnexpected>().having(
              (e) => e.postId,
              'postId',
              1,
            ),
          ),
        );
      });

      test('throws a $GetPostByIdFailureUnexpected on an unexpected error',
          () async {
        dio.interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) => handler.resolve(
              Response(
                requestOptions: RequestOptions(),
              ),
            ),
          ),
        );
        Future<void> action() => dioPostsApi.getPostById(1);
        await expectLater(
          action,
          throwsA(
            isA<GetPostByIdFailureUnexpected>().having(
              (e) => e.postId,
              'postId',
              1,
            ),
          ),
        );
      });

      test('throws a $GetPostByIdFailureNotFound on a 404 error', () async {
        dio.interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) => handler.reject(
              DioException(
                requestOptions: RequestOptions(),
                response: Response(
                  requestOptions: RequestOptions(),
                  statusCode: HttpStatus.notFound,
                ),
              ),
            ),
          ),
        );
        Future<void> action() => dioPostsApi.getPostById(1);
        await expectLater(
          action,
          throwsA(
            isA<GetPostByIdFailureNotFound>().having(
              (e) => e.postId,
              'postId',
              1,
            ),
          ),
        );
      });

      test('returns a $Post on success', () async {
        dio.interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) => handler.resolve(
              Response<Map<String, dynamic>>(
                data: <String, dynamic>{
                  'id': 1,
                  'title': 'Post 1',
                  'body': 'Body 1',
                },
                requestOptions: RequestOptions(),
              ),
            ),
          ),
        );
        final post = await dioPostsApi.getPostById(1);
        expect(
          post,
          isA<Post>()
              .having(
                (post) => post.id,
                'id',
                1,
              )
              .having(
                (post) => post.title,
                'title',
                'Post 1',
              )
              .having(
                (post) => post.body,
                'body',
                'Body 1',
              ),
        );
      });
    });
  });
}
