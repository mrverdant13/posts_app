part of 'posts_bloc.dart';

sealed class PostsBlocEvent extends Equatable {
  const PostsBlocEvent();
}

class PostsRequested extends PostsBlocEvent {
  const PostsRequested();

  @override
  List<Object> get props => [];
}

class PostsRefreshed extends PostsBlocEvent {
  const PostsRefreshed();

  @override
  List<Object> get props => [];
}
