part of 'post_bloc.dart';

sealed class PostBlocEvent extends Equatable {
  const PostBlocEvent();
}

class PostSet extends PostBlocEvent {
  const PostSet({
    required this.post,
  });

  final Post post;

  @override
  List<Object> get props => [post];
}

class PostRequested extends PostBlocEvent {
  const PostRequested({
    required this.postId,
  });

  final int postId;

  @override
  List<Object> get props => [postId];
}
