import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// {@template posts_api.get_post_by_id_failure}
/// An exception that is thrown when retrieving a post fails.
/// {@endtemplate}
@immutable
sealed class GetPostByIdFailure extends Equatable implements Exception {
  /// {@macro posts_api.get_post_by_id_failure}
  const GetPostByIdFailure({
    required this.postId,
  });

  /// The ID of the post.
  final int postId;

  @override
  List<Object> get props => [postId];
}

/// {@template posts_api.get_post_by_id_failure_unexpected}
/// An exception that is thrown when an unexpected error occurs while retrieving
/// a post.
/// {@endtemplate}
@immutable
class GetPostByIdFailureUnexpected extends GetPostByIdFailure {
  /// {@macro posts_api.get_post_by_id_failure_unexpected}
  const GetPostByIdFailureUnexpected({
    required super.postId,
    required this.error,
  });

  /// The underlying error.
  final Object error;

  @override
  List<Object> get props => [
        ...super.props,
        error,
      ];
}

/// {@template posts_api.get_post_by_id_failure_not_found}
/// An exception that is thrown when a post is not found.
/// {@endtemplate}
@immutable
class GetPostByIdFailureNotFound extends GetPostByIdFailure {
  /// {@macro posts_api.get_post_by_id_failure_not_found}
  const GetPostByIdFailureNotFound({
    required super.postId,
  });
}
