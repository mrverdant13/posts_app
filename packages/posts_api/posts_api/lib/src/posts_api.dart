import 'package:posts_api/posts_api.dart';

/// {@template posts_api.posts_api}
/// An interface for an API to manage posts.
/// {@endtemplate}
abstract interface class PostsApi {
  /// Retrieves a [PostsPage].
  ///
  /// Throws a [GetPostsPageFailure] if an exception occurs.
  Future<PostsPage> getPostsPage({
    required int offset,
    required int limit,
  });

  /// Retrieves a [Post] by its [postId].
  ///
  /// Throws a [GetPostByIdFailure] if an exception occurs.
  Future<Post> getPostById(int postId);
}
