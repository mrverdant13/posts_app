import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:posts_api/posts_api.dart';

/// {@template posts_api.posts_page}
/// A page of [Post]s.
/// {@endtemplate}
@immutable
class PostsPage extends Equatable {
  /// {@macro posts_api.posts_page}
  const PostsPage({
    required this.posts,
    required this.postsCount,
  });

  /// {@template posts_api.posts_page.posts}
  /// The posts in this page.
  /// {@endtemplate}
  final List<Post> posts;

  /// {@template posts_api.posts_page.posts_count}
  /// The total number of posts.
  /// {@endtemplate}
  final int postsCount;

  @override
  List<Object> get props => [posts, postsCount];
}
