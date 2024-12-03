import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// {@template posts_api.get_posts_page_failure}
/// An exception that is thrown when retrieving a page of posts fails.
/// {@endtemplate}
@immutable
sealed class GetPostsPageFailure extends Equatable implements Exception {
  /// {@macro posts_api.get_posts_page_failure}
  const GetPostsPageFailure({
    required this.offset,
    required this.limit,
  });

  /// The offset of the page.
  final int offset;

  /// The limit of the page.
  final int limit;

  @override
  List<Object> get props => [offset, limit];
}

/// {@template posts_api.get_posts_page_failure_unexpected}
/// An exception that is thrown when an unexpected error occurs while retrieving
/// a page of posts.
/// {@endtemplate}
@immutable
class GetPostsPageFailureUnexpected extends GetPostsPageFailure {
  /// {@macro posts_api.get_posts_page_failure_unexpected}
  const GetPostsPageFailureUnexpected({
    required super.offset,
    required super.limit,
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
