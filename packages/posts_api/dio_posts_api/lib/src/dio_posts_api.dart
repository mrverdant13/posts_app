import 'dart:math';

import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:posts_api/posts_api.dart';

/// {@template dio_posts_api.dio_posts_api}
/// An API to manage posts, built on top of Dio.
/// {@endtemplate}
final class DioPostsApi implements PostsApi {
  /// {@macro dio_posts_api}
  DioPostsApi({
    required this.dio,
    required String postsImagesBaseUrl,
  }) : postsImagesBaseUri = Uri.parse(postsImagesBaseUrl);

  /// The underlying Dio client.
  @visibleForTesting
  final Dio dio;

  /// The base URL for the posts images.
  @visibleForTesting
  final Uri postsImagesBaseUri;

  /// The internal random number generator.
  @visibleForTesting
  static final random = Random();

  /// The height of the images.
  static const imageHeight = 150;

  /// The width of the images.
  static const imageWidth = 400;

  /// Builds the image URI for a post.
  @visibleForTesting
  Uri buildImageUri({
    required int postId,
  }) {
    final additionalPathSegments = [
      '$postId',
      '$imageWidth',
      '$imageHeight',
    ];
    return postsImagesBaseUri.replace(
      pathSegments: [
        ...postsImagesBaseUri.pathSegments,
        ...additionalPathSegments,
      ],
    );
  }

  /// Builds the [ImageData] for a post.
  @visibleForTesting
  ImageData buildImageData({
    required int postId,
  }) {
    final imageUri = buildImageUri(postId: postId);
    return ImageData(
      url: imageUri.toString(),
      width: imageWidth,
      height: imageHeight,
    );
  }

  /// Builds the [PostCategory] for a post.
  @visibleForTesting
  PostCategory buildPostCategory({
    required int postId,
  }) {
    final categoryIndex = postId % PostCategory.values.length;
    return PostCategory.values[categoryIndex];
  }

  @override
  Future<PostsPage> getPostsPage({
    required int offset,
    required int limit,
  }) async {
    try {
      final response = await dio.get<List<dynamic>>(
        '/posts',
        queryParameters: {
          '_start': offset,
          '_limit': limit,
        },
      );
      final posts = [
        for (final json in response.data ?? <Map<String, Object?>>[])
          Post.fromJsonWithBuilders(
            json: json as Map<String, Object?>,
            imageBuilder: buildImageData,
            categoryBuilder: buildPostCategory,
          ),
      ];
      final rawPostsCount = response.headers.map['X-Total-Count']?.first;
      final postsCount = int.parse(rawPostsCount!);
      return PostsPage(
        posts: posts,
        postsCount: postsCount,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        GetPostsPageFailureUnexpected(
          offset: offset,
          limit: limit,
          error: error,
        ),
        stackTrace,
      );
    }
  }

  @override
  Future<Post> getPostById(int postId) async {
    try {
      final response = await dio.get<Map<String, Object?>>(
        '/posts/$postId',
      );
      return Post.fromJsonWithBuilders(
        json: response.data!,
        imageBuilder: buildImageData,
        categoryBuilder: buildPostCategory,
      );
    } on DioException catch (error, stackTrace) {
      if (error.response?.statusCode == 404) {
        Error.throwWithStackTrace(
          GetPostByIdFailureNotFound(postId: postId),
          stackTrace,
        );
      }
      Error.throwWithStackTrace(
        GetPostByIdFailureUnexpected(
          postId: postId,
          error: error,
        ),
        stackTrace,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        GetPostByIdFailureUnexpected(
          postId: postId,
          error: error,
        ),
        stackTrace,
      );
    }
  }
}
