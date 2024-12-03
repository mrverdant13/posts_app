import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:posts_api/posts_api.dart';

/// {@template posts_api.post}
/// A post.
/// {@endtemplate}
@immutable
class Post extends Equatable {
  /// {@macro posts_api.post}
  const Post({
    required this.id,
    required this.title,
    required this.body,
    required this.category,
    required this.image,
  });

  /// Creates a [Post] from a JSON object.
  factory Post.fromJsonWithBuilders({
    required Map<String, dynamic> json,
    required ImageData Function({required int postId}) imageBuilder,
    required PostCategory Function({required int postId}) categoryBuilder,
  }) {
    final id = json['id'] as int;
    return Post(
      id: id,
      title: json['title'] as String,
      body: json['body'] as String,
      category: categoryBuilder(postId: id),
      image: imageBuilder(postId: id),
    );
  }

  /// The post ID.
  final int id;

  /// The post title.
  final String title;

  /// The post body.
  final String body;

  /// The category of the post.
  final PostCategory category;

  /// The post image.
  final ImageData image;

  @override
  List<Object> get props => [id, title, body, category, image];
}
