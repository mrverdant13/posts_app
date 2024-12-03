part of 'posts_bloc.dart';

class PostsBlocState extends Equatable {
  const PostsBlocState({
    required this.posts,
    required this.postsCount,
    required this.isLoading,
    required this.error,
  });

  const PostsBlocState.initial()
      : posts = null,
        postsCount = 0,
        isLoading = false,
        error = null;

  final List<Post>? posts;
  final int postsCount;
  final bool isLoading;
  final Object? error;

  PostsBlocState copyWith({
    List<Post>? Function()? posts,
    int? postsCount,
    bool? isLoading,
    Object? Function()? error,
  }) {
    return PostsBlocState(
      posts: posts != null ? posts() : this.posts,
      postsCount: postsCount ?? this.postsCount,
      isLoading: isLoading ?? this.isLoading,
      error: error != null ? error() : this.error,
    );
  }

  @override
  List<Object?> get props => [
        posts,
        postsCount,
        isLoading,
        error,
      ];
}
